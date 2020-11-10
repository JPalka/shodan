# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logs', type: :request do
  describe 'GET /logs' do
    context 'with no params' do
      it 'returns first page of logs and total count' do
        create_list(:log, 50)

        get '/logs'
        aggregate_failures "correct response" do
          expect(response).to have_http_status(200)
          expect(json.first.count).to eq(10)
          expect(json.second).to eq(50)
        end
      end
    end

    context 'pagination' do
      it 'returns second page' do
        logs = create_list(:log, 50)
        expected_result = JSON.parse(logs.reverse.slice(10, 10).to_json)

        get '/logs?page=2'
        aggregate_failures 'correct response' do
          expect(response).to have_http_status(200)
          expect(json.first).to eq(expected_result)
        end
      end

      it 'returns last page' do
        logs = create_list(:log, 33)
        expected_result = JSON.parse(logs.reverse.slice(30, 10).to_json)

        get '/logs?page=4'
        aggregate_failures 'correct response' do
          expect(response).to have_http_status(200)
          expect(json.first).to eq(expected_result)
        end
      end
    end

    context 'filter by severity' do
      it 'filters by single severity' do
        _logs_info = create_list(:log, 2, :info)
        logs_warn = create_list(:log, 5, :warn)
        expected_result = JSON.parse(logs_warn.reverse.to_json)

        get '/logs?severity[]=WARN'

        expect(json.first).to eq(expected_result)
      end

      it 'filters by multiple severities' do
        _log_info = create(:log, :info)
        log_warn = create(:log, :warn)
        log_debug = create(:log, :debug)
        expected_result = JSON.parse([log_debug, log_warn].to_json)

        get '/logs?severity[]=WARN&severity[]=DEBUG'
        expect(json.first).to eq(expected_result)
      end

      it 'paginates with severity' do
        logs_info = create_list(:log, 10, :info)
        _logs_warn = create_list(:log, 5, :warn)
        logs_info_second = create_list(:log, 2, :info)
        expected_result = JSON.parse((logs_info + logs_info_second).reverse.take(10).to_json)
        expected_result_page_two = JSON.parse(logs_info.take(2).reverse.to_json)

        get '/logs?severity[]=INFO'
        aggregate_failures 'first page' do
          expect(json.first).to eq(expected_result)
          expect(json.second).to eq(12)
        end
        get '/logs?severity[]=INFO&page=2'
        aggregate_failures 'second page' do
          expect(json.first).to eq(expected_result_page_two)
          expect(json.second).to eq(12)
        end
      end
    end
  end
end

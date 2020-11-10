# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logs', type: :request do
  describe 'GET /logs' do
    context 'with no params' do
      it 'returns first page of logs and total count' do
        create_list(:log, 50)

        get '/logs'
        json
        aggregate_failures "correct response" do
          expect(response).to have_http_status(200)
          expect(json.first.count).to eq(10)
          expect(json.second).to eq(50)
        end
      end
    end
  end
end

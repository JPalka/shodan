require 'rails_helper'

RSpec.describe "MasterServers", type: :request do
  let!(:master_servers) { create_list(:master_server, 15) }
  let(:master_server_id) { master_servers.first.id }

  describe 'GET /master_servers' do
    before { get '/master_servers' }

    it 'returns server list' do
      expect(json).not_to be_empty
      expect(json.size).to eq(15)
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /master_servers/:id' do
    before { get "/master_servers/#{master_server_id}" }

    context 'when server exists' do
      it 'returns server' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(master_server_id)
      end

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when server does not exist' do
      let(:master_server_id) { 999_999_999 }

      it 'returns 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find MasterServer/)
      end
    end
  end

  describe 'PATCH /master_servers/:id' do
    let(:valid_data) { { link: 'https://yologames.net' } }

    context 'when server exists' do
      before { put "/master_servers/#{master_server_id}", params: valid_data }
      let(:server) { MasterServer.find(master_server_id) }

      it 'changes server link' do
        expect(server.link).to eq(valid_data[:link])
      end
      it 'returns 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'POST /master_servers' do
    let(:valid_data) { { link: 'https://newserver.com' } }

    context 'when request is valid' do
      before { post '/master_servers', params: valid_data }

      it 'creates server' do
        expect(json['link']).to eq('https://newserver.com')
      end

      it 'returns 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request is invalid' do
      before { post '/master_servers', params: { link: '' } }
      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Link can't be blank/)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end

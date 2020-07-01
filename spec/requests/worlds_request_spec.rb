require 'rails_helper'

RSpec.describe "Worlds", type: :request do
  let!(:master_server) { create(:master_server) }
  let!(:worlds) { create_list(:world, 5, master_server_id: master_server.id) }

  let(:server_id) { master_server.id }
  let(:id) { worlds.first.id }

  describe 'GET /master_servers/:master_server/worlds' do
    before { get "/master_servers/#{server_id}/worlds" }

    context 'when server exists' do
      it { expect(response).to have_http_status(200) }

      it 'returns world list' do
        expect(json.size).to eq(5)
      end
    end

    context 'when server does not exist' do
      let(:server_id) { 0 }

      it { expect(response).to have_http_status(404) }

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find MasterServer/)
      end
    end
  end

  describe 'GET /master_servers/:master_server/worlds/:id' do
    before { get "/master_servers/#{server_id}/worlds/#{id}" }

    context 'when world exists' do
      it { expect(response).to have_http_status(200) }

      it 'returns world info' do
        expect(json['id']).to eq(id)
        expect(json).to include('id', 'name', 'link', 'master_server_id', 'world_config', 'unit_config', 'building_config')
      end
    end

    context 'when world does not exist' do
      let(:id) { 0 }
      it { expect(response).to have_http_status(404) }

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find World/)
      end
    end
  end
end

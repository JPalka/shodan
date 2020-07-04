# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Players', type: :request do
  let!(:world) { create(:world_with_players) }
  let(:id) { world.players.first.id }
  let(:world_id) { world.id }

  describe 'GET /worlds/:world/players' do
    before { get "/worlds/#{world_id}/players" }

    context 'when world exists' do
      it { expect(response).to have_http_status(200) }

      it 'returns all players in world' do
        expect(json.size).to eq(world.players.count)
      end
    end

    context 'when world does not exist' do
      let(:world_id) { 0 }

      it { expect(response).to have_http_status(404) }

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find World/)
      end
    end
  end

  describe 'GET /worlds/:world/players/:id' do
    before { get "/worlds/#{world_id}/players/#{id}" }

    context 'player exists' do
      it { expect(response).to have_http_status(200) }
      it 'returns account info' do
        expect(json['id']).to eq(id)
        expect(json).to include('id', 'external_id', 'name', 'points', 'rank', 'world_id', 'account_id')
      end
    end

    context 'player does not exist' do
      let(:id) { 0 }

      it { expect(response).to have_http_status(404) }
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Player/)
      end
    end
  end
end

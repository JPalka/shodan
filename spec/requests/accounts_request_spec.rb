require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  let!(:master_server) { create(:master_server) }
  let!(:accounts) { create_list(:account, 5, master_server_id: master_server.id) }

  let(:server_id) { master_server.id }
  let(:id) { accounts.first.id }

  describe 'GET /master_servers/:master_server/accounts' do
    before { get "/master_servers/#{server_id}/accounts" }

    context 'when server exists' do
      it 'returns 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all accounts on server' do
        expect(json.size).to eq(5)
      end
    end

    context 'when server does not exist' do
      let(:server_id) { 0 }

      it 'returns 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find MasterServer/)
      end
    end
  end

  describe 'GET /master_servers/:master_server/accounts/:id' do
    before { get "/master_servers/#{server_id}/accounts/#{id}" }

    context 'when account exists' do
      it 'returns 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns account info' do
        expect(json['id']).to eq(id)
        expect(json).to include('id', 'login', 'password', 'email', 'master_server_id', 'premium_points')
      end
    end

    context 'when account does not exist' do
      let(:id) { 'oompaloompa' }
      it 'returns 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Account/)
      end
    end
  end

  describe 'POST /master_servers/:master_server/accounts' do
    let(:valid_data) { { login: 'tester', password: 'gnojowica1000', email: 'some@email.com' } }

    context 'with valid attributes' do
      before { post "/master_servers/#{server_id}/accounts", params: valid_data }

      it 'creates account' do
        expect(json['login']).to eq('tester')
        expect(json['password']).to eq('gnojowica1000')
        expect(json['email']).to eq('some@email.com')
        expect(json['master_server_id']).to eq(server_id)
      end
      it 'returns 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid request' do
      before { post "/master_servers/#{server_id}/accounts", params: { login: '', password: 'oof', email: 'doof@moof.pl' } }

      it 'returns 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation error message' do
        expect(response.body).to match(/Validation failed: Login can't be blank/)
      end
    end
  end

  describe 'PATCH /master_servers/:master_server/accounts/:id' do
    let(:valid_data) { { password: 'new_password1' } }
    before { put "/master_servers/#{server_id}/accounts/#{id}", params: valid_data }

    context 'when item exists' do
      let(:account) { Account.find(id) }
      it 'returns 204' do
        expect(response).to have_http_status(204)
      end

      it 'changes account data' do
        expect(account.reload.password).to eq(valid_data[:password])
      end
    end
  end
end

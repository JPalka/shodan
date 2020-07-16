# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_server
  before_action :set_account, only: %i[show update]

  def index
    json_response(@server.accounts)
  end

  def show
    json_response(@account)
  end

  def create
    new_account = @server.accounts.create!(account_params)
    json_response(new_account, :created)
  end

  def update
    @account.update(account_params)
    # binding.pry
    head :no_content
  end

  private

  def account_params
    params.permit(:login, :password, :email, active_world_ids: [])
  end

  def set_account
    @account = Account.find(params[:id])
  end

  def set_server
    return unless params[:master_server_id]

    @server = MasterServer.find(params[:master_server_id])
  end
end

class AccountsController < ApplicationController
  before_action :set_server
  before_action :set_account, only: [:show, :update]

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
    head :no_content
  end

  private

  def account_params
    params.permit(:login, :password, :email)
  end

  def set_account
    @account = Account.find(params[:id])
  end

  def set_server
    @server = MasterServer.find(params[:master_server_id])
  end
end

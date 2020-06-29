class MasterServersController < ApplicationController
  before_action :set_server, only: [:show, :update]

  def index
    json_response(MasterServer.all)
  end

  def show
    json_response(@server)
  end

  def create
    @server = MasterServer.create!(server_params)
    json_response(@server, :created)
  end

  def update
    @server.update(server_params)
    head :no_content
  end

  private

  def server_params
    params.permit(:link)
  end

  def set_server
    @server = MasterServer.find(params[:id])
  end
end

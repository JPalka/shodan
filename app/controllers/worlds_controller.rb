class WorldsController < ApplicationController
  before_action :set_server
  before_action :set_world, only: [:show]

  def index
    json_response(@server.worlds)
  end

  def show
    json_response(@world)
  end

  private

  def set_world
    @world = World.find(params[:id])
  end

  def set_server
    @server = MasterServer.find(params[:master_server_id])
  end
end
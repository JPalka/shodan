# frozen_string_literal: true

class WorldsController < ApplicationController
  before_action :set_server
  before_action :set_world, only: [:show]

  def index
    json_response(@server.worlds)
  end

  def show
    json_response(@world, extra_methods: %i[player_count village_count])
  end

  private

  def set_world
    @world = World.find(params[:id])
  end

  def set_server
    return unless params[:master_server_id]

    @server = MasterServer.find(params[:master_server_id])
  end
end

# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_world
  before_action :set_player, only: :show

  def index
    json_response(@world.players)
  end

  def show
    json_response(@player)
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end

  def set_world
    return unless params[:world_id]

    @world = World.find(params[:world_id])
  end
end

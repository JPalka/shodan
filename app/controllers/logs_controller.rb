# frozen_string_literal: true

class LogsController < ApplicationController
  def index
    res = AI::Logs::FilterQuery.new(AI::Log.query, logs_params)
    json_response(res.call)
  end

  def show
  end

  private

  def logs_params
    params.permit(:page, :per_page, severity: [])
  end
end

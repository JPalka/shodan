# frozen_string_literal: true

class AIController < ApplicationController
  before_action :worker_manager

  def create
    result = @worker_manager.create_worker(ai_params)
    if result.nil?
      json_response('worker manager unavailable', :service_unavailable)
    else
      json_response(result, :created)
    end
  end

  def index
    result = @worker_manager.worker_list
    if result.nil?
      json_response('worker manager unavailable', :service_unavailable)
    else
      json_response(result, :ok)
    end
  end

  def destroy
    result = @worker_manager.stop_worker(worker_id: params[:id])
    if result.nil?
      json_response('worker manager unavailable', :service_unavailable)
    else
      json_response(result, :ok)
    end
  end

  private

  def worker_manager
    @worker_manager ||= WorkerManagerService.new('worker_manager')
  end

  def ai_params
    params.require(:account)
  end
end

# frozen_string_literal: true

class AIController < ApplicationController
  def create
    service = WorkerManagerService.new('worker_manager')
    result = service.create_worker(ai_params)
    if result.nil?
      json_response('worker manager unavailable', :service_unavailable)
    else
      json_response(result, :created)
    end
  end

  private

  def ai_params
    params.require(:account)
  end
end

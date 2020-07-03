# frozen_string_literal: true

module Response
  def json_response(object, status = :ok, extra_methods: [])
    render json: object, methods: extra_methods, status: status
  end
end

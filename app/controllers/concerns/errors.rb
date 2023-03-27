module Errors
  extend ActiveSupport::Concern

  def render_error(error = "Error", message = nil, status = :bad_request)
    render json: { error:, message: }, status:
  end

  def bad_request(message = nil)
    render_error("Bad Request", message, :bad_request)
  end

  def not_found(message = nil)
    render_error("Not Found", message, :not_found)
  end

  def unauthorized(message = nil)
    render_error("Unauthorized", message, :unauthorized)
  end
end

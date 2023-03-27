class EndpointsController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def handler
    # return bad_request if user_token.blank?

    # user = User.find_by(token: user_token)

    # return bad_request if user.blank?

    return bad_request if client.blank?
    return bad_request if client_request.blank?
    return not_found if client_response.blank?

    render(
      json: client_response.body,
      status: client_response.status,
      headers: client_response.headers,
    )
  end

  private

  def bad_request
    render json: { error: "Bad Request" }, status: :bad_request
  end

  def not_found
    render json: { error: "Not Found" }, status: :not_found
  end

  def user_token
    request.headers["Authorization"]&.split(" ")&.last
  end

  def client
    @client ||= Client.find_by(slug: request.path_parameters[:client])
  end

  def client_request
    @client_request ||= client.requests.find_by(
      path: "/#{request.path_parameters[:path]}",
      method: request.method.downcase,
    )
  end

  def client_response
    @client_response ||=
      client_request.responses.detect do |client_response|
        client_response.conditions.all? do |(key, value)|
          params[key] == value
        end
      end
  end
end

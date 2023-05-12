# frozen_string_literal: true

# rubocop:disable Rails/ApplicationController

class EndpointsController < ActionController::Base
  include Errors

  skip_before_action :verify_authenticity_token

  def handler
    return unauthorized("Missing authentication token.") if
      user_token.blank?

    return unauthorized("Invalid authentication token.") if
      user.blank?

    return unauthorized("Expired oauth session.") if
      user.oauth_expired?

    return bad_request("Client not found.") if
      client.blank?

    return not_found("Request with given path not found.") if
      client_request.blank?

    create_request_log

    return not_found("Response not found.") if
      client_response.blank?

    render(
      client_response_format => client_response.body,
      status: client_response.status,
      headers: client_response.headers,
    )
  end

  private

  def user_token
    request.headers["Authorization"]&.split(" ")&.last
  end

  def user
    @user ||= User.find_by(token: user_token)
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

  def client_response_format
    @client_response_format ||= client_response.format_before_type_cast.to_sym
  end

  def create_request_log
    RequestLogger.new(
      user,
      request,
      client_request,
      client_response,
    ).call
  end
end

# rubocop:enable Rails/ApplicationController

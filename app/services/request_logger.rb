# frozen_string_literal: true

#
# RequestLogger
#
# This class is responsible for logging requests and responses.
#
# The response body is ommitted from the log as it may contain sensitive
# information and the S3 version may not have been the same as the version that
# was sent to the client at the time of the request.
#
class RequestLogger
  #
  # Initializes a new instance of the RequestLogger class.
  #
  # @param [User] user
  # @param [ActionDispatch::Request] request
  # @param [Request] client_request
  # @param [Index] client_index
  # @param [Response] client_response
  #
  def initialize(user, request, client_request, client_index, client_response)
    @user = user
    @request = request
    @client_request = client_request
    @client_index = client_index
    @client_response = client_response
  end

  def call
    remove_old_logs

    Log.create!(
      request: @client_request,
      data: {
        user: user_hash,
        request: request_hash,
        response: response_hash,
      },
    )
  end

  private

  def remove_old_logs
    conditions = { created_at: ...1.month.ago }

    return unless Log.exists?(conditions)

    Log.where(conditions).delete_all
  end

  def user_hash
    {
      id: @user.id,
      provider: @user.provider,
      uid: @user.provider_uid,
      email: @user.provider_email,
    }
  end

  def request_hash
    {
      name: @client_request.name,
      client: @request.path_parameters[:client],
      path: @request.path,
      query_params: @request.query_parameters.to_h,
      body_params: @request.request_parameters.to_h,
      user_agent: @request.user_agent,
      ip: @request.ip,
    }
  end

  def index_hash
    {
      id: @client_index.id,
      name: @client_index.name,
      status: @client_index.status,
      throttle: @client_index.throttle,
      headers: @client_index.headers,
      properties: @client_index.properties,
    }
  end

  def response_hash
    return index_hash if @client_index.present?

    return { status: 500 } if @client_response.blank?

    {
      id: @client_response.id,
      name: @client_response.name,
      status: @client_response.status,
      throttle: @client_response.throttle,
      headers: @client_response.headers,
      conditions: @client_response.conditions,
    }
  end
end

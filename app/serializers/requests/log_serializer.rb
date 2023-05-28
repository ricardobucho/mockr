# frozen_string_literal: true

module Requests
  class LogSerializer < Panko::Serializer
    attributes(
      :id,
      :data,
      :created_at,
      :request_user_agent,
      :request_user_agent?,
      :request_ip,
      :request_ip?,
      :request_params,
      :request_params?,
      :response_name,
      :response_name?,
      :response_status,
      :response_status?,
      :response_throttle,
      :response_throttle?,
      :response_headers,
      :response_headers?,
      :response_conditions,
      :response_conditions?,
    )

    def request_user_agent = object.data.dig("request", "user_agent")
    def request_user_agent? = request_user_agent.present?

    def request_ip = object.data.dig("request", "ip")
    def request_ip? = request_ip.present?

    def request_params = object.data.dig("request", "params", "endpoint") || []
    def request_params? = request_params.present?

    def response_name = object.data.dig("response", "name")
    def response_name? = response_name.present?

    def response_status = object.data.dig("response", "status")
    def response_status? = response_status.present?

    def response_throttle = object.data.dig("response", "throttle") || 0
    def response_throttle? = response_throttle.present?

    def response_headers = object.data.dig("response", "headers") || []
    def response_headers? = response_headers.present?

    def response_conditions = object.data.dig("response", "conditions") || []
    def response_conditions? = response_conditions.present?
  end
end

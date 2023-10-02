# frozen_string_literal: true

module Requests
  class LogSerializer < Panko::Serializer
    attributes(
      :id,
      :data,
      :created_at,
      :created_at_formatted,
      :request_user_agent,
      :request_user_agent?,
      :request_ip,
      :request_ip?,
      :request_query_params,
      :request_query_params?,
      :request_body_params,
      :request_body_params?,
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
      :response_properties,
      :response_properties?,
    )

    def created_at_formatted = object.created_at.strftime("%Y-%m-%d %H:%M:%S %Z")

    def request_user_agent = object.data.dig("request", "user_agent")
    def request_user_agent? = request_user_agent.present?

    def request_ip = object.data.dig("request", "ip")
    def request_ip? = request_ip.present?

    def request_query_params = object.data.dig("request", "query_params")
    def request_query_params? = request_query_params.present?

    def request_body_params = object.data.dig("request", "body_params", "endpoint")
    def request_body_params? = request_body_params.present?

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

    def response_properties = object.data.dig("response", "properties") || []
    def response_properties? = response_properties.present?
  end
end

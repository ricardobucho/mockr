# frozen_string_literal: true

module Requests
  class LogSerializer < Panko::Serializer
    attributes(
      :id,
      :data,
      :created_at,
      :request_params,
      :request_params?,
      :response_name,
      :response_status,
      :response_headers,
      :response_headers?,
      :response_conditions,
      :response_conditions?,
    )

    def request_params = object.data.dig("request", "params", "endpoint") || []
    def request_params? = request_params.present?

    def response_name = object.data.dig("response", "name")
    def response_status = object.data.dig("response", "status")

    def response_headers = object.data.dig("response", "headers") || []
    def response_headers? = response_headers.present?

    def response_conditions = object.data.dig("response", "conditions") || []
    def response_conditions? = response_conditions.present?
  end
end

# frozen_string_literal: true

module EndpointResponses
  class Index < Dry::Struct
    transform_keys(&:to_sym)

    attribute :request, Types.Instance(::Request)
    attribute :index, Types.Instance(::Index)
    attribute :params, Types.Instance(ActionController::Parameters)

    def call
      request.responses.select do |response|
        response.format == Response.formats.key("json") &&
          response.body.to_s.downcase.include?(params[:q].to_s.downcase)
      end.filter_map do |response|
        with_template(index.template, response.body)
      end
    end

    private

    def with_template(index_template, response_body)
      template = ERB.new(index_template)

      return unless valid_json?(response_body)

      json_template =
        template.result(
          template_response_class.
            new(response_body).
            instance_eval { binding },
        )

      return JSON.parse(json_template) if
        valid_json?(json_template)

      nil
    end

    def template_response_class
      @template_response_class ||=
        Class.new do
          def initialize(response)
            @response = response
          end

          def response
            JSON.parse(@response, symbolize_names: true)
          end
        end
    end

    def valid_json?(json)
      JSON.parse(json)

      true
    rescue JSON::ParserError
      false
    end
  end
end

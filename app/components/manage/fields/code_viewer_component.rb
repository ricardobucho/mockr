# frozen_string_literal: true

module Manage
  module Fields
    class CodeViewerComponent < ViewComponent::Base
      MODES = {
        json: "application/json",
        html: "text/html",
        xml: "application/xml",
        erb: "htmlmixed",
      }.freeze

      attr_reader :code, :language, :height

      def initialize(code:, language: :json, height: "auto")
        super()
        @code = code || ""
        @language = language.to_sym
        @height = height
      end

      def mode
        MODES[language] || MODES[:json]
      end
    end
  end
end

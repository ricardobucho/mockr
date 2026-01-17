# frozen_string_literal: true

module Manage
  module Fields
    class CodeEditorComponent < ViewComponent::Base
      MODES = {
        json: "application/json",
        html: "text/html",
        xml: "application/xml",
        erb: "application/x-erb"
      }.freeze

      attr_reader :form, :attribute, :label, :language, :help_text, :required, :height

      def initialize(form:, attribute:, label: :default, language: :json, help_text: nil, required: false, height: "300px")
        @form = form
        @attribute = attribute
        @label = label == :default ? attribute.to_s.humanize : label
        @language = language.to_sym
        @help_text = help_text
        @required = required
        @height = height
      end

      def mode
        MODES[language] || MODES[:json]
      end

      def field_id
        "#{form.object_name}_#{attribute}"
      end

      def field_name
        "#{form.object_name}[#{attribute}]"
      end

      def current_value
        form.object.send(attribute) || ""
      end

      def error_messages
        form.object.errors[attribute]
      end

      def has_errors?
        error_messages.any?
      end
    end
  end
end

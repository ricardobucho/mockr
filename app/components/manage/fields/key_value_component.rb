# frozen_string_literal: true

module Manage
  module Fields
    class KeyValueComponent < ViewComponent::Base
      attr_reader :form, :attribute, :label, :key_label, :value_label, :help_text, :required

      def initialize(form:, attribute:, label: :default, key_label: "Key", value_label: "Value", help_text: nil,
                     required: false)
        super()
        @form = form
        @attribute = attribute
        @label = label == :default ? attribute.to_s.humanize : label
        @key_label = key_label
        @value_label = value_label
        @help_text = help_text
        @required = required
      end

      def field_id
        "#{form.object_name}_#{attribute}"
      end

      def field_name
        "#{form.object_name}[#{attribute}]"
      end

      def current_value
        form.object.send(attribute) || {}
      end

      def rows
        current_value.to_a
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

# frozen_string_literal: true

module Manage
  class ToastComponent < ViewComponent::Base
    TYPES = {
      success: { icon: "check-circle-fill", class: "toast-success" },
      error: { icon: "exclamation-circle-fill", class: "toast-error" },
      warning: { icon: "exclamation-triangle-fill", class: "toast-warning" },
      info: { icon: "info-circle-fill", class: "toast-info" },
    }.freeze

    attr_reader :message, :type

    def initialize(message:, type: :success)
      super()
      @message = message
      @type = type.to_sym
    end

    def toast_class
      TYPES.dig(type, :class) || TYPES[:info][:class]
    end

    def icon_name
      TYPES.dig(type, :icon) || TYPES[:info][:icon]
    end
  end
end

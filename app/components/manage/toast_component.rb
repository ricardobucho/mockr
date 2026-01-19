# frozen_string_literal: true

module Manage
  class ToastComponent < ViewComponent::Base
    TYPES = {
      success: { icon: "check-circle-fill", class: "toast-success" },
      error: { icon: "exclamation-circle-fill", class: "toast-error" },
      warning: { icon: "exclamation-triangle-fill", class: "toast-warning" },
      info: { icon: "info-circle-fill", class: "toast-info" },
    }.freeze

    ACTIONS = {
      created: "created successfully",
      updated: "updated successfully",
      deleted: "deleted successfully",
    }.freeze

    attr_reader :type, :message, :resource_type, :resource_name, :action

    # Two usage patterns:
    # 1. Simple: ToastComponent.new(message: "Something happened")
    # 2. Structured: ToastComponent.new(resource_type: "Client", resource_name: "Acme", action: :created)
    def initialize(type: :success, message: nil, resource_type: nil, resource_name: nil, action: nil)
      super()
      @type = type.to_sym
      @message = message
      @resource_type = resource_type
      @resource_name = resource_name
      @action = action&.to_sym
    end

    def toast_class
      TYPES.dig(type, :class) || TYPES[:info][:class]
    end

    def icon_name
      TYPES.dig(type, :icon) || TYPES[:info][:icon]
    end

    def structured?
      resource_type.present? && action.present?
    end

    def action_text
      ACTIONS[action] || action.to_s
    end
  end
end

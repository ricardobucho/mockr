# frozen_string_literal: true

module Manage
  class DrawerComponent < ViewComponent::Base
    renders_one :header_actions

    attr_reader :title, :subtitle

    def initialize(title:, subtitle: nil)
      super()
      @title = title
      @subtitle = subtitle
    end
  end
end

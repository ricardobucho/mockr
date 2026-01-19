# frozen_string_literal: true

module Manage
  class StackedDrawerComponent < ViewComponent::Base
    attr_reader :title, :subtitle, :back_url

    def initialize(title:, subtitle: nil, back_url: nil)
      super()
      @title = title
      @subtitle = subtitle
      @back_url = back_url
    end

    def back_link?
      back_url.present?
    end
  end
end

# frozen_string_literal: true

module Manage
  class DrawerComponent < ViewComponent::Base
    attr_reader :title, :subtitle, :back_url, :back_frame

    def initialize(title:, subtitle: nil, back_url: nil, back_frame: nil)
      @title = title
      @subtitle = subtitle
      @back_url = back_url
      @back_frame = back_frame
    end

    def back_link?
      back_url.present?
    end
  end
end

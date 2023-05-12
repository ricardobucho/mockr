# frozen_string_literal: true

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Mockr
  class Application < Rails::Application
    config.load_defaults 7.0

    config.generators do |g|
      g.helpers false
      g.integration_tool false
      g.system_tests false
      g.test_framework :rspec
    end

    config.session_store :cookie_store, key: "_mockr_session"
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
  end
end

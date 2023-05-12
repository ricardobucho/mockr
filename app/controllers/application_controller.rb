# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include Errors
end

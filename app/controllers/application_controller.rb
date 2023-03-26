class ApplicationController < ActionController::Base
  include Authentication

  skip_before_action :verify_authenticity_token
end

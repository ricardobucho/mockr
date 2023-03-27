class ApplicationController < ActionController::Base
  include Authentication
  include Errors
end

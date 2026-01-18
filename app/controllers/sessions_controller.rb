# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index create failure dev_login]
  skip_before_action :validate_session!, only: %i[index create failure dev_login]

  def index
    redirect_to root_path if current_user
  end

  def create
    user = User.find_or_create_by_auth_hash(auth_hash)

    unless OrganizationManager.new(user).member?
      session[:user_id] = nil
      return redirect_to login_path, alert: "You must be a member of the organization to access this application."
    end

    session[:user_id] = user.id

    redirect_to root_path
  end

  def destroy
    Rails.logger.warn "[AUTH] Logout requested - referrer: #{request.referrer}, user: #{current_user&.id}"
    return redirect_to(login_path) unless current_user

    destroy_session!
  end

  def failure
    redirect_to root_path
  end

  # Development-only: direct login bypass
  def dev_login
    return head(:not_found) unless Rails.env.development?

    user = User.first
    session[:user_id] = user.id
    redirect_to root_path
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end

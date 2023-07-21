# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method(
      :auth_providers,
      :current_user,
      :current_user_icon,
      :logged_in?,
      :authenticate_user!,
    )

    before_action :authenticate_user!
    before_action :validate_session!
  end

  def authenticate_user!
    redirect_to(login_path) unless logged_in?
  end

  def logged_in?
    !!current_user
  end

  def validate_session!
    return if current_user.blank?
    return unless current_user.oauth_expired?

    destroy_session!
  end

  def destroy_session!
    current_user.update!(
      oauth_token: nil,
      oauth_expires_at: nil,
    )

    session[:user_id] = nil

    redirect_to(login_path)
  end

  def auth_providers
    [].tap do |array|
      if ENV.fetch("GITHUB_CLIENT_ID", nil).present?
        array << {
          name: "github",
          icon: "github",
          title: "GitHub",
        }
      end

      if ENV.fetch("OKTA_CLIENT_ID", nil).present?
        array << {
          name: "okta",
          icon: "record-circle",
          title: "Okta",
        }
      end
    end
  end

  def current_user
    return if session[:user_id].blank?

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_user_icon
    return if current_user.blank?

    return "github" if current_user.provider == "github"
    return "record-circle" if current_user.provider == "okta"

    "circle"
  end
end

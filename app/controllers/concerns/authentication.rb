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

    Rails.logger.warn "[AUTH] Session expired for user #{current_user.id}: expires_at=#{current_user.oauth_expires_at}"
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
          icon: User::PROVIDER_ICONS["github"],
          title: "GitHub",
        }
      end

      if ENV.fetch("OKTA_CLIENT_ID", nil).present?
        array << {
          name: "okta",
          icon: User::PROVIDER_ICONS["okta"],
          title: "Okta",
        }
      end
    end
  end

  def current_user
    return if session[:user_id].blank?

    if defined?(@current_user)
      @current_user
    else
      @current_user = User.find_by(id: session[:user_id])
    end
  end

  def current_user_icon
    return if current_user.blank?

    current_user.provider_icon
  end
end

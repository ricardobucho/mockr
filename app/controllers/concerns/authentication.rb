module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?, :authenticate_user!
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

  def current_user
    return if session[:user_id].blank?

    @current_user ||= User.find_by(id: session[:user_id])
  end
end

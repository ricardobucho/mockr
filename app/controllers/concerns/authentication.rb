module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?, :authenticate_user!
  end

  def current_user
    user = User.find_by(id: session[:user_id]) if session[:user_id]

    return if user.blank?

    @current_user ||= user
  end

  def logged_in?
    !!current_user
  end

  def authenticate_user!
    redirect_to(root_path) unless logged_in?
  end
end

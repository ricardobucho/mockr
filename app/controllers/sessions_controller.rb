class SessionsController < ApplicationController
  def index; end

  def create
    user = User.find_or_create_by_auth_hash(auth_hash)

    return destroy unless organization_member?(user)

    session[:user_id] = user.id

    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end

  private

  def organization_member?(user)
    return true if organization.blank?

    Octokit::Client.new(access_token: user.oauth_token).
      organization_member?("icapitalnetwork", user.provider_username)
  end

  def organization
    ENV.fetch("GITHUB_ORGANIZATION", nil)
  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end

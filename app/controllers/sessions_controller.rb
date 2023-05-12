# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index create failure]

  def index; end

  def create
    user = User.find_or_create_by_auth_hash(auth_hash)

    return destroy unless OrganizationManager.new(user).member?

    session[:user_id] = user.id

    redirect_to root_path
  end

  def destroy = destroy_session!

  def failure
    redirect_to root_path
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end

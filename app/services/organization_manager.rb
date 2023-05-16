# frozen_string_literal: true

class OrganizationManager
  def initialize(user)
    @user = user
  end

  def member?
    return false if @user.blank?
    return true if organization.blank?

    Octokit::Client.
      new(access_token: @user.oauth_token).
      organization_member?(organization, @user.provider_username)
  end

  private

  def organization
    ENV.fetch("GITHUB_ORGANIZATION", nil)
  end
end

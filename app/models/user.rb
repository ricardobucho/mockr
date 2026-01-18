# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid

  PROVIDER_ICONS = {
    "github" => "github",
    "okta" => "shield-lock"
  }.freeze

  enum role: {
    "User" => "user",
    "Manager" => "manager",
  }

  validates :token, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :provider_uid, presence: true, uniqueness: { scope: :provider }
  validates :provider_email, presence: true, uniqueness: { scope: :provider }
  validates :role, presence: true

  alias_attribute :name, :provider_username
  alias_attribute :email, :provider_email

  class << self
    def find_or_create_by_auth_hash(auth_hash)
      user = find_or_create_by(
        provider: auth_hash["provider"],
        provider_uid: auth_hash["uid"],
      )

      user.token = generate_token if user.token.blank?

      user.update!(
        provider_username: provider_nickname(auth_hash),
        provider_email: auth_hash["info"]["email"],
        oauth_token: auth_hash["credentials"]["token"],
        oauth_expires_at: auth_hash["credentials"]["expires_at"].presence || nil,
      )

      user
    end

    def generate_token
      "mkr_#{Digest::MD5.hexdigest("#{SecureRandom.hex(10)}-#{DateTime.now}")}"
    end

    def provider_nickname(auth_hash)
      return auth_hash["info"]["nickname"] if
        auth_hash["provider"] == "github"

      return auth_hash["extra"]["raw_info"]["preferred_username"] if
        auth_hash["provider"] == "okta"

      auth_hash["info"]["email"]
    end
  end

  def user? = self.class.roles[role] == "user"
  def manager? = self.class.roles[role] == "manager"

  def oauth_expired?
    oauth_expires_at.present? && oauth_expires_at < Time.current
  end

  def provider_icon
    PROVIDER_ICONS[provider] || "person-circle"
  end
end

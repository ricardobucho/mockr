class User < ApplicationRecord
  acts_as_paranoid

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
        provider_username: auth_hash["info"]["nickname"],
        provider_email: auth_hash["info"]["email"],
        oauth_token: auth_hash["credentials"]["token"],
        oauth_expires_at: Time.at(auth_hash["credentials"].fetch("expires_at", 0)),
      )

      user
    end

    def generate_token
      "mkr_#{Digest::MD5.hexdigest("#{SecureRandom.hex(10)}-#{DateTime.now}")}"
    end
  end

  def user? = self.class.roles[role] == "user"
  def manager? = self.class.roles[role] == "manager"
end

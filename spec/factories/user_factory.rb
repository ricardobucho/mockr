# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    token { SecureRandom.uuid }
    provider { "github" }
    provider_uid { SecureRandom.uuid }
    provider_email { Faker::Internet.email }
    provider_username { Faker::Internet.username }
    role { User.roles["User"] }
  end
end

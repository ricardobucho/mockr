# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    name { Faker::Company.name }
    slug { Faker::Internet.slug }
    description { Faker::Lorem.paragraph }
  end
end

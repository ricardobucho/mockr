# frozen_string_literal: true

FactoryBot.define do
  factory :request do
    client

    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    add_attribute(:method) { Request.methods["GET"] }
    path { Faker::Internet.slug }
  end
end

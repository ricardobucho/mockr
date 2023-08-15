# frozen_string_literal: true

FactoryBot.define do
  factory :index do
    request

    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    add_attribute(:method) { Index.methods["GET"] }
    path { Faker::Internet.slug }
    throttle { 0 }
    status { 200 }
  end
end

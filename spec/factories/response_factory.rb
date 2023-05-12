# frozen_string_literal: true

FactoryBot.define do
  factory :response do
    request

    name { Faker::Company.name }
    format { Response.formats["JSON"] }
    status { 200 }

    body do
      {
        id: Faker::Number.number(digits: 10),
        name: Faker::Name.name,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.phone_number,
        address: Faker::Address.full_address,
        company: Faker::Company.name,
        job: Faker::Job.title,
      }
    end
  end
end

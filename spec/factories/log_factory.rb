# frozen_string_literal: true

FactoryBot.define do
  factory :log do
    request

    data do
      {
        "key_1" => "value_1",
        "key_2" => "value_2",
        "key_3" => "value_3",
      }
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :color, class: Color do
    name { Faker::Lorem.sentence }
  end
end

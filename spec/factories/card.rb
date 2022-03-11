# frozen_string_literal: true

FactoryBot.define do
  factory :card, class: Card do
    name { Faker::Lorem.sentence }
    set { Faker::Lorem.sentence }
    rarity { Faker::Lorem.sentence }
  end
end

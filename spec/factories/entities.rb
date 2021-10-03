# frozen_string_literal: true

FactoryBot.define do
  factory :entity do
    code { nil }
    name { Faker::Lorem.word }
    description { nil }
    deactivate_at { nil }
    is_parent { false }
    parent_id { nil }
  end
end

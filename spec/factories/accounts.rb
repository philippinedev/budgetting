FactoryBot.define do
  factory :account do
    code { nil }
    description { Faker::Lorem.sentence }
    deactivated_at { nil }

    account_type
  end
end

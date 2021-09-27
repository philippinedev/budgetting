FactoryBot.define do
  factory :account_type do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
  end
end

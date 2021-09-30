FactoryBot.define do
  factory :transaction_type do
    name { Faker::Lorem.word.capitalize }
    description { Faker::Lorem.sentence }
  end
end

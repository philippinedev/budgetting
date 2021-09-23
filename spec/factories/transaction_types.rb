FactoryBot.define do
  factory :transaction_type do
    name { Faker::Lorem.word.capitalize }
    description { Faker::Lorem.sentence }
    flow { [nil, 'IN', 'OUT'].sample }
  end
end

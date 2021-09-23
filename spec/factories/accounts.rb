FactoryBot.define do
  factory :account do
    description { Faker::Lorem.sentence }
  end
end

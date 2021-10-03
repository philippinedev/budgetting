# frozen_string_literal: true

FactoryBot.define do
  factory :summary do
    transaction { nil }
    data { 'MyText' }
  end
end

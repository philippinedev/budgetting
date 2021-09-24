FactoryBot.define do
  factory :transaction do
    amount { rand(10..1000) * 100 }
    cutoff_date { nil }
    due_date { nil }
    actualized_on { [nil, nil, Date.current, Date.yesterday ].sample }

    transaction_type

    association :source_account, factory: :account
    association :target_account, factory: :account
  end
end


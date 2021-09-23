FactoryBot.define do
  factory :transaction do
    amount { rand(10..1000) * 100 }
    cut_off { "#{rand(1..31).ordinalize} of the month" }
    due_date { "#{rand(1..31).ordinalize} of the month" }
    actualized_on { [nil, nil, Date.current, Date.yesterday ].sample }

    transaction_type

    association :source_account, factory: :account
    association :target_account, factory: :account
  end
end


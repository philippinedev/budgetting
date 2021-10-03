# frozen_string_literal: true

json.extract! transaction, :id, :transaction_type_id, :account_id, :account_id, :transaction_fee, :cutoff_date,
              :due_date, :actualized_at, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)

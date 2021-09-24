json.extract! transaction, :id, :transaction_type_id, :account_id, :account_id, :amount, :cutoff_date, :due_date, :actualized_on, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)

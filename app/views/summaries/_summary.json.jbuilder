json.extract! summary, :id, :transaction_id, :transaction_name, :data, :created_at, :updated_at
json.url summary_url(summary, format: :json)

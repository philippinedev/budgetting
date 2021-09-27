json.extract! account, :id, :account_type_id, :code, :description, :deactivated_at, :created_at, :updated_at
json.url account_url(account, format: :json)

# frozen_string_literal: true

json.extract! account, :id, :account_type_id, :code, :name, :deactivated_at, :created_at, :updated_at
json.url account_url(account, format: :json)

# frozen_string_literal: true

json.extract! account_type, :id, :name, :description, :created_at, :updated_at
json.url account_type_url(account_type, format: :json)

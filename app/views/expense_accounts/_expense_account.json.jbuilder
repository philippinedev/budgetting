json.extract! expense_account, :id, :name, :description, :created_at, :updated_at
json.url expense_account_url(expense_account, format: :json)

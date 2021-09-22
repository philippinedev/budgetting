json.extract! admin_expense, :id, :name, :description, :created_at, :updated_at
json.url admin_expense_url(admin_expense, format: :json)

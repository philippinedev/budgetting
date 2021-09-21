class ChangeDataTypeForDueDate < ActiveRecord::Migration[6.1]
  def change
    change_column :transactions, :due_date, 'date USING CAST(due_date AS date)'
  end
end

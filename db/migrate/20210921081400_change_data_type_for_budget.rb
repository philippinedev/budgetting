class ChangeDataTypeForBudget < ActiveRecord::Migration[6.1]
  def change
    change_column :transactions, :budget, 'numeric USING CAST(budget AS numeric)'
  end
end

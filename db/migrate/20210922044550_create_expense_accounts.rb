class CreateExpenseAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :expense_accounts do |t|
      t.string :name, null: false, unique: true
      t.string :description

      t.timestamps
    end
  end
end

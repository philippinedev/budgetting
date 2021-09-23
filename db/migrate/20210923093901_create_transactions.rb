class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :transaction_type, null: false, foreign_key: true
      t.references :source_account,              index: true, foreign_key: { to_table: :accounts }
      t.references :target_account, null: false, index: true, foreign_key: { to_table: :accounts }
      t.integer :amount, null: false
      t.string :cut_off
      t.string :due_date
      t.date :actualized_on

      t.timestamps
    end
  end
end

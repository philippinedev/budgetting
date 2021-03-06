# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :transaction_type, null: false, foreign_key: true
      t.references :source_account,              index: true, foreign_key: { to_table: :entities }
      t.references :target_account, null: false, index: true, foreign_key: { to_table: :entities }
      t.references :expense_account,             index: true, foreign_key: { to_table: :entities }
      t.references :created_by, foreign_key: { to_table: :users }
      t.references :updated_by, foreign_key: { to_table: :users }
      t.monetize :amount, null: false
      t.monetize :fee
      t.date :cutoff_date
      t.date :due_date
      t.datetime :actualized_at

      t.timestamps
    end
  end
end

class CreateTransactionTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_types do |t|
      t.references :source_category, index: true, foreign_key: { to_table: :entities }
      t.references :target_category, index: true, foreign_key: { to_table: :entities }
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.integer :mode, null: false

      t.timestamps
    end
  end
end

class CreateTransactionTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_types do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.string :flow

      t.timestamps
    end
  end
end

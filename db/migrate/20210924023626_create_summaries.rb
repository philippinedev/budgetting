class CreateSummaries < ActiveRecord::Migration[6.1]
  def change
    create_table :summaries do |t|
      t.references :transaction, null: false, foreign_key: true
      t.string :transaction_name, null: false
      t.text :data, default: "{}"

      t.timestamps
    end
  end
end

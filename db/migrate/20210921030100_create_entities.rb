# frozen_string_literal: true

class CreateEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :entities do |t|
      t.references :parent, index: true, foreign_key: { to_table: :entities }
      t.boolean :is_parent, default: false
      t.string :code, null: false, index: { unique: true }
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.datetime :deactivated_at
      t.decimal :transaction_fee, precision: 10, scale: 2

      t.timestamps
    end
  end
end

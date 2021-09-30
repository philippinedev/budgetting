class CreateEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :entities do |t|
      t.references :parent, index: true, foreign_key: { to_table: :entities }
      t.boolean :is_parent, default: false
      t.string :code, null: false, unique: true
      t.string :name, null: false
      t.string :description
      t.datetime :deactivate_at

      t.timestamps
    end
  end
end

class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.string :flow, null: false

      t.timestamps
    end
  end
end

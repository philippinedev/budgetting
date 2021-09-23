class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :description, null: false, index: { unique: true }

      t.timestamps
    end
  end
end

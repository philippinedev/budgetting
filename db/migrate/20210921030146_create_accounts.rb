class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.references :account_type, foreign_key: true
      t.string :code, null: false
      t.string :name, null: false
      t.datetime :deactivated_at

      t.timestamps
    end
  end
end

class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.references :account_type, foreign_key: true
      t.string :code
      t.string :description
      t.datetime :deactivated_at

      t.timestamps
    end
  end
end

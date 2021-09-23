class AddCodeToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :code, :string
  end
end

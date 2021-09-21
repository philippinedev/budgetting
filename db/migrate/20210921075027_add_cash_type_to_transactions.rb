class AddCashTypeToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :cash_type, :string
  end
end

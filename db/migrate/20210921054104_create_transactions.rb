class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :name
      t.string :description
      t.string :budget
      t.string :cut_off
      t.string :due_date
      t.string :payment

      t.timestamps
    end
  end
end

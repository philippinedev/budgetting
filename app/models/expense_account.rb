class ExpenseAccount < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end

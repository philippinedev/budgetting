class Expense < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end

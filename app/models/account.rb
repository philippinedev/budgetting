class Account < ApplicationRecord
  FUNDS_TYPE = ['Cash', 'Bank']

  validates :name, presence: true, uniqueness: true
  validates :flow, presence: true

  enum flow: { expense: 'Expense', income: 'Income' }
end

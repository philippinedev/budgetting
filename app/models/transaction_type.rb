class TransactionType < ApplicationRecord
  INITIALIZE             = "Initialize".freeze
  INCOME_PROGRAMMING     = 'Income (Programming)'.freeze

  ATM_WITHDRAWAL         = 'ATM withdrawal'.freeze
  UNACCOUNTED_INCOME     = 'Unaccounted income'.freeze
  UNACCOUNTED_EXPENSE    = 'Unaccounted expense'.freeze

  SALARY_EXPENSE         = 'Salary expense'.freeze
  FOOD_EXPENSE           = 'Food expense'.freeze
  ELECTRICITY_EXPENSE    = 'Electricity expense'.freeze
  WATER_EXPENSE          = 'Water expense'.freeze
  INTERNET_EXPENSE       = 'Internet expense'.freeze
  RENT_EXPENSE           = 'Rent expense'.freeze
  TRANSPORTATION_EXPENSE = 'Transportation expense'.freeze
  ENTERTAINMENT_EXPENSE  = 'Entertainment expense'.freeze
  MISCELANEOUS_EXPENSE   = 'Miscelaneous expense'.freeze

  validates :name, presence: true, uniqueness: true
  validates :flow, inclusion: { in: [nil, 'IN', 'OUT'] }

  scope :selectable, -> { where("name != ?", INITIALIZE) }

  class << self
    def account_initializer
      first
    end
  end
end

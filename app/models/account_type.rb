class AccountType < ApplicationRecord
  BANK_ACCOUNT = "Bank Account".freeze
  CREDIT_CARD  = "Credit Card".freeze
  CASH         = "Cash".freeze
  EMPLOYER     = "Employer".freeze
  EMPLOYEE     = "Employee".freeze

  has_many :accounts
end

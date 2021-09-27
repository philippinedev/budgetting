class AccountType < ApplicationRecord
  BANK_ACCOUNT             = "Bank Account".freeze
  EMPLOYER                 = "Employer".freeze
  EMPLOYEE                 = "Employee".freeze

  has_many :accounts
end

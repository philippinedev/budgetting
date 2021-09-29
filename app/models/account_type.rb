class AccountType < ApplicationRecord
  BANK_ACCOUNT = "Bank Account".freeze
  CREDIT_CARD  = "Credit Card".freeze
  CASH         = "Cash".freeze
  EMPLOYER     = "Employer".freeze
  EMPLOYEE     = "Employee".freeze

  # Expenses
  BAHAY        = "Bahay".freeze
  ABC          = "Abc".freeze
  ZZZ          = "Zzz".freeze
  PAMAMALENGKE = "Pamamalengke".freeze

  EXPENSES = [
    BAHAY,
    PAMAMALENGKE,
    ABC,
    ZZZ
  ]

  has_many :accounts
end

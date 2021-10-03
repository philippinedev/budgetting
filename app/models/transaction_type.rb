# frozen_string_literal: true

class TransactionType < ApplicationRecord
  # ---------------------------------------------------------------
  # This part is kept for reference only.  It will be deleted soon.
  # ---------------------------------------------------------------
  # INITIALIZE             = "Initialize".freeze
  # INCOME_PROGRAMMING     = 'Income (Programming)'.freeze

  # ATM_WITHDRAWAL         = 'ATM withdrawal'.freeze
  # UNACCOUNTED_INCOME     = 'Unaccounted income'.freeze
  # UNACCOUNTED_EXPENSE    = 'Unaccounted expense'.freeze

  # SALARY_EXPENSE         = 'Salary expense'.freeze
  # FOOD_EXPENSE           = 'Food expense'.freeze
  # ELECTRICITY_EXPENSE    = 'Electricity expense'.freeze
  # WATER_EXPENSE          = 'Water expense'.freeze
  # INTERNET_EXPENSE       = 'Internet expense'.freeze
  # RENT_EXPENSE           = 'Rent expense'.freeze
  # TRANSPORTATION_EXPENSE = 'Transportation expense'.freeze
  # ENTERTAINMENT_EXPENSE  = 'Entertainment expense'.freeze
  # MISCELANEOUS_EXPENSE   = 'Miscelaneous expense'.freeze
  # ---------------------------------------------------------------

  INITIALIZE_ID = 1

  enum mode: %i[init increase_both transfer decrease_both]

  belongs_to :source_category, class_name: 'Entity', foreign_key: :source_category_id, optional: true
  belongs_to :target_category, class_name: 'Entity', foreign_key: :target_category_id, optional: true
  belongs_to :expense_category, class_name: 'Entity', foreign_key: :expense_category_id, optional: true

  validates :name, presence: true, uniqueness: true

  scope :selectable, -> { where('id > ?', INITIALIZE_ID) }

  class << self
    def account_initializer
      @@account_initializer ||= first
    end
  end
end

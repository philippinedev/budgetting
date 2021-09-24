class TransactionType < ApplicationRecord
  INITIALIZE = "Initialize".freeze

  validates :name, presence: true, uniqueness: true
  validates :flow, inclusion: { in: [nil, 'IN', 'OUT'] }

  scope :selectable, -> { where("name != ?", INITIALIZE) }

  class << self
    def account_initializer
      first
    end
  end
end

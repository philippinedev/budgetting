class TransactionType < ApplicationRecord
  validates :name, presence: true
  validates :flow, inclusion: { in: [nil, 'IN', 'OUT'] }
end

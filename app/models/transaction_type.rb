class TransactionType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :flow, inclusion: { in: [nil, 'IN', 'OUT'] }
end

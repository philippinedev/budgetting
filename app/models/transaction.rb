class Transaction < ApplicationRecord
  belongs_to :transaction_type
  belongs_to :source_account, class_name: "Account"
  belongs_to :target_account, class_name: "Account"

  validates :amount, presence: true

  validate :invalid_when_same_account

  private

  def invalid_when_same_account
    return if self.source_account_id.nil?
    return if self.target_account_id.nil?
    return unless self.source_account_id == self.target_account_id

    errors.add(:source_account, "cannot target same transaction type")
    errors.add(:target_account, "cannot source from the same transaction type")
  end
end

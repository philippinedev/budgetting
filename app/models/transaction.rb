class Transaction < ApplicationRecord
  TRANSFER = [
    "Salary Payment",
    "Rent Payment"
  ]

  monetize :amount_cents

  belongs_to :transaction_type

  belongs_to :source_account, class_name: "Entity", foreign_key: :source_account_id
  belongs_to :target_account, class_name: "Entity", foreign_key: :target_account_id

  validates :amount_cents, presence: true
  validate :invalid_when_same_account
  validate :amount_validation
  validate :source_account_validation

  after_save :update_summary, if: :actualized_at?

  scope :tran, -> { where.not(transaction_type_id: 1) }

  def actualized?
    actualized_at.present?
  end

  private

  def source_account_validation
    return if transaction_type_id == TransactionType.initialize.id

    errors.add(:source_account_id, "cannot be blank") if source_account_id.blank?
  end

  def amount_validation
    return if transaction_type_id == TransactionType.initialize.id

    errors.add(:amount, "cannot be blank") if amount.blank? || amount.to_f.zero?
  end

  def invalid_when_same_account
    return if self.source_account_id.nil?
    return if self.target_account_id.nil?
    return unless self.source_account_id == self.target_account_id

    errors.add(:source_account, "cannot target same transaction type")
    errors.add(:target_account, "cannot source from the same transaction type")
  end

  def update_summary
    case transaction_type.name
    when TransactionType::INITIALIZE
      Summary.add_key(self)

    when "Income from Programming Collection"
      Summary.increment_both(self)

    when *TRANSFER
      Summary.transfer(self)

    else
      raise "Unhandled transaction type: #{transaction_type.name}"
    end
  end
end

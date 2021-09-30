class Transaction < ApplicationRecord
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
    if transaction_type.name == TransactionType::INITIALIZE
      Summary.add_key(self)

    elsif transaction_type.name == TransactionType::INCOME_PROGRAMMING
      Summary.increment_both(self)

    elsif transaction_type.name == TransactionType::SALARY_EXPENSE
      Summary.transfer(self)

    else
      raise "Unhandled transaction type: #{transaction_type.name}"
    end
  end
end

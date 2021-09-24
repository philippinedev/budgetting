class Transaction < ApplicationRecord
  belongs_to :transaction_type
  belongs_to :source_account, class_name: "Account", optional: true
  belongs_to :target_account, class_name: "Account"

  validates :amount, presence: true
  validate :invalid_when_same_account

  before_save :amount_to_cent
  after_save :update_summary, if: :actualized_on?

  default_scope { where.not(transaction_type_id: 1) }

  class << self
    def initialize_account!(account)
      tran = new
      tran.transaction_type = TransactionType.account_initializer
      tran.target_account = account
      tran.amount = 0
      tran.actualized_on = Date.current
      tran.save!
    end
  end

  def actualized?
    actualized_on.present?
  end

  def amount_decimal
    Transaction.to_decimal(amount)
  end

  private

  def amount_to_cent
    self.amount = Transaction.to_cent(self.amount)
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

    else
      raise "Unhandled transaction type: #{transaction_type.name}"
    end
  end
end

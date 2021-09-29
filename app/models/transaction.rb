class Transaction < ApplicationRecord
  monetize :amount_cents

  belongs_to :transaction_type
  belongs_to :source_account, class_name: "Account", optional: true
  belongs_to :target_account, class_name: "Account"

  validates :amount_cents, presence: true
  validate :invalid_when_same_account
  validate :amount_validation
  validate :source_account_validation

  after_save :update_summary, if: :actualized_at?

  scope :tran, -> { where.not(transaction_type_id: 1) }

  class << self
    def initialize_account!(account)
      tran = new
      tran.transaction_type = TransactionType.account_initializer
      tran.target_account = account
      tran.amount_cents = 0
      tran.actualized_at = DateTime.current
      tran.save!
    end
  end

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

    elsif transaction_type.name == get_expense
      Summary.transfer(self)

    else
      raise "Unhandled transaction type: #{transaction_type.name}"
    end
  end

  def get_expense
    if TransactionType.expense_type.pluck(:name).map{ |x| x == transaction_type.name }
      return transaction_type.name 
    end
  end
end

class Transaction < ApplicationRecord
  monetize :amount_cents
  monetize :expense_amount_cents

  belongs_to :transaction_type

  belongs_to :source_account, class_name: "Entity", foreign_key: :source_account_id, optional: true
  belongs_to :target_account, class_name: "Entity", foreign_key: :target_account_id
  belongs_to :expense_account, class_name: "Entity", foreign_key: :expense_account_id, optional: true

  validates :amount_cents, presence: true
  validate :invalid_when_same_account
  validate :amount_validation
  validate :source_account_validation

  after_save :update_summary, if: :actualized_at?

  scope :tran, -> { where.not(transaction_type_id: 1) }

  class << self
    def init!(entity)
      source_id = entity.id == Entity::CASH ? Entity::BANK : Entity::CASH

      init_params = {
        transaction_type_id: TransactionType.account_initializer.id,
        target_account_id: entity.id,
        amount_cents: 0,
        actualized_at: DateTime.current
      }

      create(init_params)
    end
  end

  def actualized?
    actualized_at.present?
  end

  private

  def amount_validation
    return unless TransactionType.any?
    return if transaction_type_id == TransactionType.account_initializer.id
    errors.add(:amount, "cannot be blank") if amount_cents.zero?
  end

  def source_account_validation
    return unless TransactionType.any?
    return if transaction_type_id == TransactionType.account_initializer.id
    errors.add(:source_account_id, "cannot be blank") if source_account_id.blank?
  end

  def invalid_when_same_account
    return if self.source_account_id.nil?
    return if self.target_account_id.nil?
    return unless self.source_account_id == self.target_account_id

    errors.add(:source_account, "cannot target same transaction type")
    errors.add(:target_account, "cannot source from the same transaction type")
  end

  def update_summary
    if transaction_type.init?
      Summary.add_key(self)

    elsif transaction_type.increase_both?
      Summary.increment_both(self)

    elsif transaction_type.transfer?
      Summary.transfer(self)

    else
      raise "Unhandled transaction type: #{transaction_type.name}"
    end
  end
end

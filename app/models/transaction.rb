# frozen_string_literal: true

class Transaction < ApplicationRecord
  attr_accessor :is_draft
  attr_accessor :get_action

  monetize :amount_cents
  monetize :fee_cents

  belongs_to :transaction_type
  belongs_to :source_account, class_name: 'Entity', foreign_key: :source_account_id, optional: true
  belongs_to :target_account, class_name: 'Entity', foreign_key: :target_account_id
  belongs_to :expense_account, class_name: 'Entity', foreign_key: :expense_account_id, optional: true
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id, optional: true
  belongs_to :updated_by, class_name: 'User', foreign_key: :updated_by_id, optional: true
  has_one :summary

  validates :amount_cents, presence: true
  validate :invalid_when_same_account
  validate :amount_validation
  validate :source_account_validation
  validate :actualized_at_presence

  after_save :update_summary, if: :actualized_at?

  scope :tran, -> { where.not(transaction_type_id: 1) }

  class << self
    def init!(entity)
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

  def draft?
    actualized_at.nil?
  end

  private

  def actualized_at_presence
    return if actualized?
    if get_action == "create"
      errors.add(:actualized_at, 'cannot be blank') unless is_draft
    else
      return
    end
  end

  def amount_validation
    return unless TransactionType.any?
    return if transaction_type_id == TransactionType.account_initializer.id

    errors.add(:amount, 'cannot be blank') if amount_cents.zero?
  end

  def source_account_validation
    return unless TransactionType.any?
    return if transaction_type_id == TransactionType.account_initializer.id

    errors.add(:source_account_id, 'cannot be blank') if source_account_id.blank?
  end

  def invalid_when_same_account
    return if source_account_id.nil?
    return if target_account_id.nil?
    return unless source_account_id == target_account_id

    errors.add(:source_account, 'cannot target same transaction type')
    errors.add(:target_account, 'cannot source from the same transaction type')
  end

  def update_summary
    SummaryCreator.call(self)
  rescue NoMethodError => error
    raise if error.missing_name.nil?
    raise "Unhandled transaction type: #{transaction_type.name}"
  end
end

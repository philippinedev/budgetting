# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

# Seeder
class Seeder
  class << self
    def call
      new.call
    end
  end

  def initialize
    @transaction_types = []
    @accounts          = []
    @transactions      = []
  end

  def call
    ActiveRecord::Base.transaction do
      clear!
      create_initializer_type
      create_entities
      create_transaction_types
      create_transactions
    end

    display_results
  end

  private

  def clear!
    Summary.destroy_all
    Transaction.destroy_all
    TransactionType.destroy_all
    Entity.destroy_all
  end

  def create_initializer_type
    TransactionType.create(name: 'Initialize', mode: TransactionType.modes[:init])
  end

  def create_entities
    EntitiesCreator.call
  end

  def create_transaction_types
    tt_rent_payment
    tt_internet_payment
    tt_salary_payment
    tt_income_from_programming_collection
    tt_atm_withdrawal_without_fee
    tt_atm_withdrawal_with_fee
    tt_credit_card_unidentified_expense
    tt_credit_card_payment
    tt_groceries_mall
    tt_groceries_other
  end

  def create_transactions
    TransactionsSeeder.call
  end

  def display_results
    puts
    puts '-------------------------------'
    puts 'Seed results:'
    puts '-------------------------------'
    puts "Transaction Types: #{TransactionType.count}"
    puts "Accounts         : #{Entity.accounts.count}"
    puts "Transactions     : #{Transaction.count}"
    puts "Summary          : #{Summary.count}"
  end

  def tt_rent_payment
    @tt_rent_payment ||= TransactionType.create(
      name: 'Rent Payment',
      source_category_id: @cashables.id,
      target_category_id: @rent_expense.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_internet_payment
    @tt_internet_payment ||= TransactionType.create(
      name: 'Internet Payment',
      source_category_id: @cashables.id,
      target_category_id: @internet_expense.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_salary_payment
    @tt_salary_payment ||= TransactionType.create(
      name: 'Salary Payment',
      source_category_id: @cashables.id,
      target_category_id: @salary_expense.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_income_from_programming_collection
    @tt_income_from_programming_collection ||= TransactionType.create(
      name: 'Income from Programming Collection',
      source_category_id: @income_programming.id,
      target_category_id: @bank_account.id,
      mode: TransactionType.modes[:increase_both]
    )
  end

  def tt_atm_withdrawal_without_fee
    @tt_atm_withdrawal_without_fee ||= TransactionType.create(
      name: 'ATM Withdrawal (Own Bank)',
      source_category_id: @bank_account.id,
      target_category_id: @cash_on_hand.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_atm_withdrawal_with_fee
    @tt_atm_withdrawal_with_fee ||= TransactionType.create(
      name: 'ATM Withdrawal (Another Bank)',
      source_category_id: @bank_account.id,
      target_category_id: @cash_on_hand.id,
      expense_category_id: @atm_withdraway_charge.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_credit_card_unidentified_expense
    @tt_credit_card_unidentified_expense ||= TransactionType.create(
      name: 'Credit Card (Unidentified Expense)',
      source_category_id: @credit_cards.id,
      target_category_id: @unidentified_cc_expense.id,
      mode: TransactionType.modes[:increase_both]
    )
  end

  def tt_groceries_mall
    @tt_groceries_mall ||= TransactionType.create(
      name: 'Groceries at Mall (cc)',
      source_category_id: @credit_cards.id,
      target_category_id: @groceries_mall.id,
      mode: TransactionType.modes[:increase_both]
    )
  end

  def tt_groceries_other
    @tt_groceries_other ||= TransactionType.create(
      name: 'Groceries Other (cash)',
      source_category_id: @cash_on_hand.id,
      target_category_id: @groceries_other.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_credit_card_payment
    @tt_credit_card_payment ||= TransactionType.create(
      name: 'Credit Card Payment',
      source_category_id: @cashables.id,
      target_category_id: @credit_cards.id,
      mode: TransactionType.modes[:decrease_both]
    )
  end
end

Seeder.call

# rubocop:enable Metrics/ClassLength

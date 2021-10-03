# frozen_string_literal: true

# Transactions seeder
class TransactionsSeeder # rubocop:disable Metrics/ClassLength
  class << self
    def call(param)
      new(param).call
    end
  end

  def initialize(param)
    @bdo_account1 = param[0]
    @cash_on_hand = param[1]
    @cc_bdo_ins = param[2]
    @cc_bdo_pri = param[3]
    @cc_metrobank = param[4]
    @cc_rcbc_flex = param[5]
    @cc_rcbc_ins = param[6]
    @cc_rcbc_pri = param[7]
    @erich = param[8]
    @morphosis = param[9]
    @tt_atm_withdrawal_with_fee = param[10]
    @tt_atm_withdrawal_without_fee = param[11]
    @tt_credit_card_unidentified_expense = param[12]
    @tt_income_from_programming_collection = param[13]
    @unidentified_cc_expense = param[14]
  end

  def call
    income_from_programming_erich
    income_from_programming_morphosis
    atm_withdrawal_with_fee
    atm_withdrawal_without_fee
    credit_card_unidentified_expense_bdo_pri
    credit_card_unidentified_expense_bdo_ins
    credit_card_unidentified_expense_rcbc_pri
    credit_card_unidentified_expense_rcbc_flex
    credit_card_unidentified_expense_rcbc_ins
    credit_card_unidentified_expense_metrobank
  end

  def income_from_programming_erich
    Transaction.create(
      transaction_type_id: @tt_income_from_programming_collection.id,
      source_account_id: @erich.id,
      target_account_id: @bdo_account1.id,
      amount: 150_000,
      actualized_at: DateTime.current
    )
  end

  def income_from_programming_morphosis
    Transaction.create(
      transaction_type_id: @tt_income_from_programming_collection.id,
      source_account_id: @morphosis.id,
      target_account_id: @bdo_account1.id,
      amount: 150_000,
      actualized_at: DateTime.current
    )
  end

  def atm_withdrawal_with_fee
    Transaction.create(
      transaction_type_id: @tt_atm_withdrawal_with_fee.id,
      source_account_id: @bdo_account1.id,
      target_account_id: @cash_on_hand.id,
      amount: 50_000,
      actualized_at: DateTime.current
    )
  end

  def atm_withdrawal_without_fee
    Transaction.create(
      transaction_type_id: @tt_atm_withdrawal_without_fee.id,
      source_account_id: @bdo_account1.id,
      target_account_id: @cash_on_hand.id,
      amount: 50_000,
      actualized_at: DateTime.current
    )
  end

  def credit_card_unidentified_expense_bdo_pri
    Transaction.create(
      transaction_type_id: @tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_bdo_pri.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
  end

  def credit_card_unidentified_expense_bdo_ins
    Transaction.create(
      transaction_type_id: @tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_bdo_ins.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
  end

  def credit_card_unidentified_expense_rcbc_pri
    Transaction.create(
      transaction_type_id: @tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_rcbc_pri.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
  end

  def credit_card_unidentified_expense_rcbc_flex
    Transaction.create(
      transaction_type_id: @tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_rcbc_flex.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
  end

  def credit_card_unidentified_expense_rcbc_ins
    Transaction.create(
      transaction_type_id: @tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_rcbc_ins.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
  end

  def credit_card_unidentified_expense_metrobank
    Transaction.create(
      transaction_type_id: @tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_metrobank.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
  end
end

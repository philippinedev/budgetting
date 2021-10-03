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
    TransactionType.create(name: "Initialize", mode: TransactionType.modes[:init])
  end

  def create_entities
    expense  = Entity.create(name: "Expenses")

    @tran_expense  = Entity.create(
      id: Entity::TRANSACTION_CHARGES_ID,
      name: "Transaction Expenses",
      parent_id: expense.id
    )
    @atm_withdraway_charge = Entity.create(
      name: "ATM Withdrawal Charge",
      parent_id: @tran_expense.id,
      transaction_fee: 18.0
    )

    @unidentified_expense    = Entity.create(name: "Unidentified Expenses", parent_id: expense.id)
    @unidentified_cc_expense = Entity.create(name: "Unidentified Credit Card Expenses", parent_id: @unidentified_expense.id)

    @groceries       = Entity.create(name: "Groceries", parent_id: expense.id)
    @groceries_mall  = Entity.create(name: "Groceries at Mall", parent_id: @groceries.id)
    @groceries_other = Entity.create(name: "Groceries (other)", parent_id: @groceries.id)

    @salary_expense    = Entity.create(name: "Salary Expenses", parent_id: expense.id)
    Entity.create(name: 'Ever Jedi Usbal', parent_id: @salary_expense.id)
    Entity.create(name: 'Don Forrest Usbal', parent_id: @salary_expense.id)
    Entity.create(name: 'Abe Cambarihan', parent_id: @salary_expense.id)
    Entity.create(name: 'Lester Quiñones', parent_id: @salary_expense.id)
    Entity.create(name: 'Paulo Benemerito', parent_id: @salary_expense.id)
    Entity.create(name: 'Abbie Mercado', parent_id: @salary_expense.id)

    @rent_expense      = Entity.create(name: "Rent Expenses", parent_id: expense.id)
    Entity.create(name: "Issa House Mid", parent_id: @rent_expense.id)
    Entity.create(name: "Issa House Back", parent_id: @rent_expense.id)
    Entity.create(name: "Calderon House", parent_id: @rent_expense.id)

    @internet_expense  = Entity.create(name: "Internet Expenses", parent_id: expense.id)
    Entity.create(name: "PLDT Landline", parent_id: @internet_expense.id)
    Entity.create(name: "Converge Issa", parent_id: @internet_expense.id)
    Entity.create(name: "Converge Calderon", parent_id: @internet_expense.id)

    @cashables = Entity.create(name: "Cashables")
    @cash_on_hand = Entity.create(name: "Cash on Hand", parent_id: @cashables.id)
    @bank_account = Entity.create(name: "Bank Account", parent_id: @cashables.id)

    @bdo_account_1 = Entity.create(name: "BDO Acct: 005010246385", parent_id: @bank_account.id)

    @credit_cards = Entity.create(name: "Credit Card Payables")
    @cc_bdo_pri   = Entity.create(name: 'CC BDO PRI Payable', parent_id: @credit_cards.id)
    @cc_bdo_ins   = Entity.create(name: 'CC BDO INS Payable', parent_id: @credit_cards.id)
    @cc_rcbc_pri  = Entity.create(name: 'CC RCBC PRI Payable', parent_id: @credit_cards.id)
    @cc_rcbc_flex = Entity.create(name: 'CC RCBC FLEX Payable', parent_id: @credit_cards.id)
    @cc_rcbc_jcb  = Entity.create(name: 'CC RCBC JCB Payable', parent_id: @credit_cards.id)
    @cc_rcbc_ins  = Entity.create(name: 'CC RCBC INS Payable', parent_id: @credit_cards.id)
    @cc_metrobank = Entity.create(name: 'CC METROBANK', parent_id: @credit_cards.id)

    @income = Entity.create(name: "Incomes")
    @unidentified_income = Entity.create(name: "Unidentified Incomes", parent_id: @income.id)
    @income_programming  = Entity.create(name: "Income from programming", parent_id: @income.id)
    @erich     = Entity.create(name: "Erich (Germany)", parent_id: @income_programming.id)
    @morphosis = Entity.create(name: "Morphosis (Thailand)", parent_id: @income_programming.id)
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
    Transaction.create(
      transaction_type_id: tt_income_from_programming_collection.id,
      source_account_id: @erich.id,
      target_account_id: @bdo_account_1.id,
      amount: 150_000,
      actualized_at: DateTime.current
    )
    Transaction.create(
      transaction_type_id: tt_income_from_programming_collection.id,
      source_account_id: @morphosis.id,
      target_account_id: @bdo_account_1.id,
      amount: 150_000,
      actualized_at: DateTime.current
    )
    Transaction.create(
      transaction_type_id: tt_atm_withdrawal_with_fee.id,
      source_account_id: @bdo_account_1.id,
      target_account_id: @cash_on_hand.id,
      amount: 50_000,
      actualized_at: DateTime.current
    )
    Transaction.create(
      transaction_type_id: tt_atm_withdrawal_without_fee.id,
      source_account_id: @bdo_account_1.id,
      target_account_id: @cash_on_hand.id,
      amount: 50_000,
      actualized_at: DateTime.current
    )

    Transaction.create(
      transaction_type_id: tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_bdo_pri.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
    Transaction.create(
      transaction_type_id: tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_bdo_ins.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
    Transaction.create(
      transaction_type_id: tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_rcbc_pri.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
    Transaction.create(
      transaction_type_id: tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_rcbc_flex.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
    Transaction.create(
      transaction_type_id: tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_rcbc_ins.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
    Transaction.create(
      transaction_type_id: tt_credit_card_unidentified_expense.id,
      source_account_id: @cc_metrobank.id,
      target_account_id: @unidentified_cc_expense.id,
      amount: 100_000,
      actualized_at: 1.month.ago
    )
  end

  def display_results
    puts
    puts "-------------------------------"
    puts "Seed results:"
    puts "-------------------------------"
    puts "Transaction Types: #{TransactionType.count}"
    puts "Accounts         : #{Entity.accounts.count}"
    puts "Transactions     : #{Transaction.count}"
    puts "Summary          : #{Summary.count}"
  end

  private

  def tt_rent_payment
    @tt_rent_payment ||= TransactionType.create(
      name: "Rent Payment",
      source_category_id: @cashables.id,
      target_category_id: @rent_expense.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_internet_payment
    @tt_internet_payment ||= TransactionType.create(
      name: "Internet Payment",
      source_category_id: @cashables.id,
      target_category_id: @internet_expense.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_salary_payment
    @tt_salary_payment ||= TransactionType.create(
      name: "Salary Payment",
      source_category_id: @cashables.id,
      target_category_id: @salary_expense.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_income_from_programming_collection
    @tt_income_from_programming_collection ||= TransactionType.create(
      name: "Income from Programming Collection",
      source_category_id: @income_programming.id,
      target_category_id: @bank_account.id,
      mode: TransactionType.modes[:increase_both]
    )
  end

  def tt_atm_withdrawal_without_fee
    @tt_atm_withdrawal_without_fee ||= TransactionType.create(
      name: "ATM Withdrawal (Own Bank)",
      source_category_id: @bank_account.id,
      target_category_id: @cash_on_hand.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_atm_withdrawal_with_fee
    @tt_atm_withdrawal_with_fee ||= TransactionType.create(
      name: "ATM Withdrawal (Another Bank)",
      source_category_id: @bank_account.id,
      target_category_id: @cash_on_hand.id,
      expense_category_id: @atm_withdraway_charge.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_credit_card_unidentified_expense
    @tt_credit_card_unidentified_expense ||= TransactionType.create(
      name: "Credit Card (Unidentified Expense)",
      source_category_id: @credit_cards.id,
      target_category_id: @unidentified_cc_expense.id,
      mode: TransactionType.modes[:increase_both]
    )
  end

  def tt_groceries_mall
    @tt_groceries_mall ||= TransactionType.create(
      name: "Groceries at Mall (cc)",
      source_category_id: @credit_cards.id,
      target_category_id: @groceries_mall.id,
      mode: TransactionType.modes[:increase_both]
    )
  end

  def tt_groceries_other
    @tt_groceries_other ||= TransactionType.create(
      name: "Groceries Other (cash)",
      source_category_id: @cash_on_hand.id,
      target_category_id: @groceries_other.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_credit_card_payment
    @tt_credit_card_payment ||= TransactionType.create(
      name: "Credit Card Payment",
      source_category_id: @cashables.id,
      target_category_id: @credit_cards.id,
      mode: TransactionType.modes[:decrease_both]
    )
  end
end

Seeder.call


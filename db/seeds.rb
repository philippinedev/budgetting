# def create_accounts
#   # Cash
#   create(name: 'Cash on bank (BDO)', account_type_id: @bank_type.id)
#   create(name: 'Cash on hand', account_type_id: @cash_type.id)

#   # Credit Cards
#   create(name: 'CC BDO PRI', account_type_id: @cc_type.id)
#   create(name: 'CC BDO LOAN', account_type_id: @cc_type.id)
#   create(name: 'CC RCBC PRI', account_type_id: @cc_type.id)
#   create(name: 'CC RCBC FLEX', account_type_id: @cc_type.id)
#   create(name: 'CC RCBC JCB', account_type_id: @cc_type.id)
#   create(name: 'CC RCBC LOAN', account_type_id: @cc_type.id)
#   create(name: 'CC METROBANK', account_type_id: @cc_type.id)

#   # Employees
#   create(name: 'Ever Jedi Usbal', account_type_id: @employee_type.id)
#   create(name: 'Don Forrest Usbal', account_type_id: @employee_type.id)
#   create(name: 'Abe Cambarihan', account_type_id: @employee_type.id)
#   create(name: 'Lester Quiñones', account_type_id: @employee_type.id)
#   create(name: 'Paulo Benemerito', account_type_id: @employee_type.id)
#   create(name: 'Abbie Mercado', account_type_id: @employee_type.id)

#   # Clients
#   create(name: 'Erich (Germany)', account_type_id: @employer_type.id)
#   create(name: 'Morphosis (Thailand)', account_type_id: @employer_type.id)
# end

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
    expense  = Entity.create(name: "Expense")

    @tran_expense  = Entity.create(id: Entity::TRANSACTION_CHARGES_ID, name: "Transaction Expense")
    @atm_withdraway_charge = Entity.create(name: "ATM Withdrawal Charge", parent_id: @tran_expense.id, amount: 18.0)

    @salary_expense    = Entity.create(name: "Salary Expense", parent_id: expense.id)
    Entity.create(name: 'Ever Jedi Usbal', parent_id: @salary_expense.id)
    Entity.create(name: 'Don Forrest Usbal', parent_id: @salary_expense.id)
    Entity.create(name: 'Abe Cambarihan', parent_id: @salary_expense.id)
    Entity.create(name: 'Lester Quiñones', parent_id: @salary_expense.id)
    Entity.create(name: 'Paulo Benemerito', parent_id: @salary_expense.id)
    Entity.create(name: 'Abbie Mercado', parent_id: @salary_expense.id)

    @rent_expense      = Entity.create(name: "Rent Expense", parent_id: expense.id)
    Entity.create(name: "Issa House", parent_id: @rent_expense.id)
    Entity.create(name: "Calderon House", parent_id: @rent_expense.id)

    @internet_expense  = Entity.create(name: "Internet Expense", parent_id: expense.id)
    Entity.create(name: "PLDT Landline", parent_id: @internet_expense.id)
    Entity.create(name: "Converge Issa", parent_id: @internet_expense.id)
    Entity.create(name: "Converge Calderon", parent_id: @internet_expense.id)

    @cashable = Entity.create(name: "Cashable")
    @cash_on_hand = Entity.create(name: "Cash on Hand", parent_id: @cashable.id)
    @bank_account = Entity.create(name: "Bank Account", parent_id: @cashable.id)

    @bdo_account_1 = Entity.create(name: "BDO Acct: 005010246385", parent_id: @bank_account.id)

    @income = Entity.create(name: "Income")
    @income_programming = Entity.create(name: "Income from programming", parent_id: @income.id)
    Entity.create(name: "Erich (Germany)", parent_id: @income_programming.id)
    Entity.create(name: "Morphosis (Thailand)", parent_id: @income_programming.id)
  end

  def create_transaction_types
    tt_rent_payment
    tt_internet_payment
    tt_salary_payment
    tt_income_from_programming_collection
    tt_atm_withdrawal_without_fee
    tt_atm_withdrawal_with_fee
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

  def create(limit, &block)
    n = 0
    while n < limit
      begin
        block.call
        n += 1
      rescue ActiveRecord::RecordInvalid => error
        # puts error.to_s
      end
    end
  end

  private

  def tt_rent_payment
    TransactionType.create(
      name: "Rent Payment",
      source_category_id: @cashable.id,
      target_category_id: @rent_expense.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_internet_payment
    TransactionType.create(
      name: "Internet Payment",
      source_category_id: @cashable.id,
      target_category_id: @internet_expense.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_salary_payment
    TransactionType.create(
      name: "Salary Payment",
      source_category_id: @cashable.id,
      target_category_id: @salary_expense.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_income_from_programming_collection
    TransactionType.create(
      name: "Income from Programming Collection",
      source_category_id: @income_programming.id,
      target_category_id: @bank_account.id,
      mode: TransactionType.modes[:increase_both]
    )
  end

  def tt_atm_withdrawal_without_fee
    TransactionType.create(
      name: "ATM Withdrawal (Own Bank)",
      source_category_id: @bank_account.id,
      target_category_id: @cash_on_hand.id,
      mode: TransactionType.modes[:transfer]
    )
  end

  def tt_atm_withdrawal_with_fee
    TransactionType.create(
      name: "ATM Withdrawal (Another Bank)",
      source_category_id: @bank_account.id,
      target_category_id: @cash_on_hand.id,
      expense_category_id: @atm_withdraway_charge.id,
      mode: TransactionType.modes[:transfer]
    )
  end
end

Seeder.call


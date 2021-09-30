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
      create_entities
      create_transaction_types
      # create_account_types
      # create_accounts
      display_results
    end
  end

  private

  def clear!
    Entity.destroy_all
    # Summary.destroy_all
    # Transaction.destroy_all
    # Account.destroy_all
    TransactionType.destroy_all
    # AccountType.destroy_all
  end

  def create_entities
    @account_creation  = Entity.create(name: "Account Creation")

    expense  = Entity.create(name: "Expense")

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
    Entity.create(name: "Bank Account (BDO)", parent_id: @cashable.id)
    Entity.create(name: "Cash on Hand", parent_id: @cashable.id)
  end

  # def create_account_types
  #   @bank_type     = AccountType.create(name: AccountType::BANK_ACCOUNT)
  #   @cc_type       = AccountType.create(name: AccountType::CREDIT_CARD)
  #   @cash_type     = AccountType.create(name: AccountType::CASH)
  #   @employee_type = AccountType.create(name: AccountType::EMPLOYEE)
  #   @employer_type = AccountType.create(name: AccountType::EMPLOYER)
  # end

  # def create_accounts
  #   # Cash
  #   Account.create(name: 'Cash on bank (BDO)', account_type_id: @bank_type.id)
  #   Account.create(name: 'Cash on hand', account_type_id: @cash_type.id)

  #   # Credit Cards
  #   Account.create(name: 'CC BDO PRI', account_type_id: @cc_type.id)
  #   Account.create(name: 'CC BDO LOAN', account_type_id: @cc_type.id)
  #   Account.create(name: 'CC RCBC PRI', account_type_id: @cc_type.id)
  #   Account.create(name: 'CC RCBC FLEX', account_type_id: @cc_type.id)
  #   Account.create(name: 'CC RCBC JCB', account_type_id: @cc_type.id)
  #   Account.create(name: 'CC RCBC LOAN', account_type_id: @cc_type.id)
  #   Account.create(name: 'CC METROBANK', account_type_id: @cc_type.id)

  #   # Employees
  #   Account.create(name: 'Ever Jedi Usbal', account_type_id: @employee_type.id)
  #   Account.create(name: 'Don Forrest Usbal', account_type_id: @employee_type.id)
  #   Account.create(name: 'Abe Cambarihan', account_type_id: @employee_type.id)
  #   Account.create(name: 'Lester Quiñones', account_type_id: @employee_type.id)
  #   Account.create(name: 'Paulo Benemerito', account_type_id: @employee_type.id)
  #   Account.create(name: 'Abbie Mercado', account_type_id: @employee_type.id)

  #   # Clients
  #   Account.create(name: 'Erich (Germany)', account_type_id: @employer_type.id)
  #   Account.create(name: 'Morphosis (Thailand)', account_type_id: @employer_type.id)
  # end

  def create_transaction_types
    TransactionType.create(name: "Initialize", source_category_id: @cashable.id, target_category_id: @account_creation.id)
    TransactionType.create(name: "Rent Payment", source_category_id: @cashable.id, target_category_id: @rent_expense.id)
    TransactionType.create(name: "Internet Payment", source_category_id: @cashable.id, target_category_id: @internet_expense.id)
    TransactionType.create(name: "Salary Payment", source_category_id: @cashable.id, target_category_id: @salary_expense.id)

  #   TransactionType.create(name: TransactionType::INITIALIZE, flow: "IN")

  #   TransactionType.create(name: TransactionType::INCOME_PROGRAMMING, flow: "IN")

  #   TransactionType.create(name: TransactionType::ATM_WITHDRAWAL)
  #   TransactionType.create(name: TransactionType::UNACCOUNTED_INCOME,  flow: "IN")
  #   TransactionType.create(name: TransactionType::UNACCOUNTED_EXPENSE, flow: "OUT")

  #   TransactionType.create(name: TransactionType::SALARY_EXPENSE,         flow: "OUT")
  #   TransactionType.create(name: TransactionType::FOOD_EXPENSE,           flow: "OUT")
  #   TransactionType.create(name: TransactionType::ELECTRICITY_EXPENSE,    flow: "OUT")
  #   TransactionType.create(name: TransactionType::WATER_EXPENSE,          flow: "OUT")
  #   TransactionType.create(name: TransactionType::INTERNET_EXPENSE,       flow: "OUT")
  #   TransactionType.create(name: TransactionType::RENT_EXPENSE,           flow: "OUT")
  #   TransactionType.create(name: TransactionType::TRANSPORTATION_EXPENSE, flow: "OUT")
  #   TransactionType.create(name: TransactionType::ENTERTAINMENT_EXPENSE,  flow: "OUT")
  #   TransactionType.create(name: TransactionType::MISCELANEOUS_EXPENSE,   flow: "OUT")
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
end

Seeder.call


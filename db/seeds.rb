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
    clear!
    create_transaction_types
    create_accounts
    # create_transactions(50)
    display_results
  end

  private

  def clear!
    Transaction.destroy_all
    Account.destroy_all
    TransactionType.destroy_all
    Summary.destroy_all
  end

  def create_transaction_types
    TransactionType.create(name: TransactionType::INITIALIZE, flow: "IN")

    TransactionType.create(name: TransactionType::INCOME_PROGRAMMING, flow: "IN")

    TransactionType.create(name: TransactionType::ATM_WITHDRAWAL)
    TransactionType.create(name: TransactionType::UNACCOUNTED_INCOME,  flow: "IN")
    TransactionType.create(name: TransactionType::UNACCOUNTED_EXPENSE, flow: "OUT")

    TransactionType.create(name: TransactionType::SALARY_EXPENSE,         flow: "OUT")
    TransactionType.create(name: TransactionType::FOOD_EXPENSE,           flow: "OUT")
    TransactionType.create(name: TransactionType::ELECTRICITY_EXPENSE,    flow: "OUT")
    TransactionType.create(name: TransactionType::WATER_EXPENSE,          flow: "OUT")
    TransactionType.create(name: TransactionType::INTERNET_EXPENSE,       flow: "OUT")
    TransactionType.create(name: TransactionType::RENT_EXPENSE,           flow: "OUT")
    TransactionType.create(name: TransactionType::TRANSPORTATION_EXPENSE, flow: "OUT")
    TransactionType.create(name: TransactionType::ENTERTAINMENT_EXPENSE,  flow: "OUT")
    TransactionType.create(name: TransactionType::MISCELANEOUS_EXPENSE,   flow: "OUT")
  end

  def create_accounts
    # Cash
    Account.create(description: 'Cash on bank (BDO)')
    Account.create(description: 'Cash on hand')

    # Credit Cards
    Account.create(description: 'CC BDO PRI')
    Account.create(description: 'CC BDO LOAN')
    Account.create(description: 'CC RCBC PRI')
    Account.create(description: 'CC RCBC JCB')
    Account.create(description: 'CC RCBC LOAN')
    Account.create(description: 'CC METROBANK')

    # Employees
    Account.create(description: 'Ever Jedi Usbal')
    Account.create(description: 'Don Forrest Usbal')
    Account.create(description: 'Abe Cambarihan')
    Account.create(description: 'Lester Quiñones')
    Account.create(description: 'Paulo Benemerito')
    Account.create(description: 'Abbie Mercado')

    # Clients
    Account.create(description: 'Erich (Germany)')
    Account.create(description: 'Morphosis (Thailand)')
  end

  def create_transactions(limit)
    create(limit) do
      @transactions << FactoryBot.create(
        :transaction,
        transaction_type: @transaction_types.sample,
        source_account: @accounts.sample,
        target_account: @accounts.sample
      )
    end
  end

  def display_results
    puts
    puts "-------------------------------"
    puts "Seed results:"
    puts "-------------------------------"
    puts "Transaction Types: #{TransactionType.count}"
    puts "Accounts         : #{Account.count}"
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


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
    create_transaction_types(10)
    create_accounts(10)
    create_transactions(50)
    display_results
  end

  private

  def clear!
    Transaction.destroy_all
    Account.destroy_all
    TransactionType.destroy_all
  end

  def create_transaction_types(limit)
    create(limit) do
      @transaction_types << FactoryBot.create(:transaction_type)
    end
  end

  def create_accounts(limit)
    limit.times do
      @accounts << FactoryBot.create(:account)
    end
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
  end

  def create(limit, &block)
    n = 0
    while n < limit
      begin
        block.call
        n += 1
      rescue => error
        puts error.to_s
      end
    end
  end
end

Seeder.call


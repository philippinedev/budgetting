def seeder
  Transaction.destroy_all
  Account.destroy_all
  TransactionType.destroy_all

  transaction_types = []
  10.times do
    transaction_types << FactoryBot.create(:transaction_type)
  end

  accounts = []
  10.times do
    accounts << FactoryBot.create(:account)
  end

  n = 0
  while true
    begin
      FactoryBot.create(
        :transaction,
        transaction_type: transaction_types.sample,
        source_account: accounts.sample,
        target_account: accounts.sample
      )
      n += 1
      break if n == 50
    rescue
      puts "Same source and target not valid.  Disregarding..."
    end
  end

  puts
  puts "-------------------------------"
  puts "Seed results:"
  puts "-------------------------------"
  puts "Transaction Types: #{TransactionType.count}"
  puts "Accounts         : #{Account.count}"
  puts "Transactions     : #{Transaction.count}"
end

seeder


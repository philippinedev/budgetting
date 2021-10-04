class SummaryCreator
  class << self
    def call(*args)
      new(*args).call
    end
  end

  def initialize(tran)
    @tran = tran
    @sdata = SummaryData.new(Summary.last_data)
  end

  def call
    Summary.create(
      transaction_id: @tran.id,
      data: update_data
    )
  end

  def update_data
    if @tran.transaction_type.init?
      @sdata.send("#{@tran.target_account.code}_cents=", 0)
      puts "Init: #{@tran.target_account.name}"

    elsif @tran.transaction_type.increase_both?
      @sdata.send("#{@tran.source_account.code}_cents+=", @tran.amount_cents)
      @sdata.send("#{@tran.target_account.code}_cents+=", @tran.amount_cents)

    elsif @tran.transaction_type.transfer?
      @sdata.send("#{@tran.source_account.code}_cents-=", @tran.amount_cents)
      @sdata.send("#{@tran.target_account.code}_cents+=", @tran.amount_cents)

    elsif @tran.transaction_type.decrease_both?
      @sdata.send("#{@tran.source_account.code}_cents-=", @tran.amount_cents)
      @sdata.send("#{@tran.target_account.code}_cents-=", @tran.amount_cents)
    end

    @sdata.to_json
  end
end

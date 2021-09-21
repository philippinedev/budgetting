class TransactionsController < ApplicationController

  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(trans_params)
    if @transaction.save
      redirect_to transactions_path
    else
      render :new
    end
  end

  private

  def trans_params
    params
      .require(:transaction)
      .permit(:name, :description, :budget, :cut_off, :due_date, :payment)
  end

end

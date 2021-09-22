class TransactionsController < ApplicationController
  before_action :set_trans, only: [:show]

  def index
    @transactions = Transaction.all.order("created_at DESC")
  end

  def new
    @transaction = Transaction.new
  end

  def show; ends

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
      .permit(:name, :description, :budget, :cut_off, :due_date, :payment, :cash_type)
  end

  def set_trans
    @transaction = Transaction.find(params[:id])
  end

end

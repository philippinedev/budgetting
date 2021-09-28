class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  def index
    @transactions = Transaction.order(created_at: :desc)
  end

  def show
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
end

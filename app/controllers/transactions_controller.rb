class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  def index
    @transactions = Transaction.order(created_at: :desc)
    @last_tran = Summary.last.tran
  end

  def show
  end

  def update
    raise "Cannot update an actualized transaction!" if already_actualized?

    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to root_path, notice: "Draft transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    raise "Cannot delete an actualized transaction!" if already_actualized?

    @transaction.delete
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Draft transaction was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  def already_actualized?
    @transaction.actualized_at_before_last_save.present?
  end

  def transaction_params
    params.require(:transaction).permit(
      :transaction_type_id,
      :source_account_id,
      :target_account_id,
      :amount,
      :cutoff_date,
      :due_date,
      :actualized_at
    )
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
end

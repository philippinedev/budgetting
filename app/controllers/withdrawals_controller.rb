class WithdrawalsController < ApplicationController
  before_action :set_withdrawal, only: [:edit, :update]

  def new
    @withdrawal = Transaction.new
  end

  def create
    @withdrawal = Transaction.new(transaction_params)
    @withdrawal.transaction_type_id = TransactionType.withdrawal.id

    respond_to do |format|
      if @withdrawal.save
        notice = "#{@withdrawal.actualized? ? "" : "Draft "} Withdrawal was successfully saved."
        format.html { redirect_to root_path, notice: notice }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @withdrawal.update(transaction_params)
        notice = "#{@withdrawal.actualized? ? "" : "Draft "} Withdrawal was successfully updated."
        format.html { redirect_to root_path, notice: notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(
      :source_account_id,
      :target_account_id,
      :amount,
      :cutoff_date,
      :due_date,
      :actualized_at
    )
  end

  def set_withdrawal
    @withdrawal = Transaction.find(params[:id])
  end
end

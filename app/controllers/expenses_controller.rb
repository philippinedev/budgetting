class ExpensesController < ApplicationController
  before_action :set_expense, only: [:edit, :update]

  def new
    @expense = Transaction.new
  end

  def create
    @expense = Transaction.new(transaction_params)

    respond_to do |format|
      if @expense.save
        notice = "#{@expense.actualized? ? "" : "Draft "} Expense was successfully saved."
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
      if @expense.update(transaction_params)
        notice = "#{@expense.actualized? ? "" : "Draft "} Income was successfully updated."
        format.html { redirect_to root_path, notice: notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

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

  def set_expense
    @expense = Transaction.find(params[:id])
  end
end

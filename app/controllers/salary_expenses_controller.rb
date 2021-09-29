class SalaryExpensesController < ApplicationController
  before_action :set_salary, only: [:edit, :update]

  def new
    @salary = Transaction.new
  end

  def create
    @salary = Transaction.new(transaction_params)
    @salary.transaction_type_id = TransactionType.salary.id

    respond_to do |format|
      if @salary.save
        notice = "#{@salary.actualized? ? "" : "Draft "} Salary expense was successfully saved."
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
      if @salary.update(transaction_params)
        notice = "#{@salary.actualized? ? "" : "Draft "} Salary expense was successfully updated."
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

  def set_salary
    @salary = Transaction.find(params[:id])
  end
end

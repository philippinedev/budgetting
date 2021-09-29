class SalaryExpensesController < ApplicationController
  def new
    gon.push(params.require(:f).permit!.to_h) if params.has_key?(:f)
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

  private

  def transaction_params
    params.require(:transaction).permit(
      :source_account_id,
      :target_account_id,
      :amount,
      :cutoff_date,
      :due_date,
      :actualized_on
    )
  end
end

class IncomesController < ApplicationController
  def new
    gon.push(params.require(:f).permit!.to_h) if params.has_key?(:f)
    @income = Transaction.new
  end

  def create
    @income = Transaction.new(transaction_params)
    @income.transaction_type_id = TransactionType.income.id

    respond_to do |format|
      if @income.save
        format.html { redirect_to root_path, notice: "Income was successfully saved." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(
      :amount,
      :source_account_id,
      :target_account_id,
      :cutoff_date,
      :due_date,
      :actualized_on
    )
  end
end

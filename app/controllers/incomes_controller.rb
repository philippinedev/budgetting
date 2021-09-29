class IncomesController < ApplicationController
  before_action :set_income, only: [:edit, :update]

  def new
    gon.push(params.require(:f).permit!.to_h) if params.has_key?(:f)
    @income = Transaction.new
  end

  def create
    @income = Transaction.new(transaction_params)
    @income.transaction_type_id = TransactionType.income.id

    respond_to do |format|
      if @income.save
        notice = "#{@income.actualized? ? "" : "Draft "} Income was successfully saved."
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
      if @income.update(transaction_params)
        notice = "#{@income.actualized? ? "" : "Draft "} Income was successfully updated."
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

  def set_income
    @income = Transaction.find(params[:id])
  end
end

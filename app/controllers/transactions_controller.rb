# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show edit update destroy]

  def index
    @transactions = Transaction.tran.order(created_at: :desc)
    @last_tran = Summary.last&.tran
  end

  def new
    @transaction = Transaction.new
    set_tran_types_for_frontend
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.transaction_type&.expense_category_id?
      @transaction.expense_account = @transaction.transaction_type.expense_category
      @transaction.fee = @transaction.transaction_type.expense_category.transaction_fee
    end

    if @transaction.save
      notice = "#{@transaction.actualized? ? '' : 'Draft'} Transaction was successfully created."
      redirect_to root_path, notice: notice
    else
      set_tran_types_for_frontend
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  def edit
    set_transaction
    set_tran_types_for_frontend
  end

  def update
    raise 'Cannot update an actualized transaction!' if already_actualized?

    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to root_path, notice: 'Draft transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    raise 'Cannot delete an actualized transaction!' if already_actualized?

    @transaction.delete
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Draft transaction was successfully deleted.' }
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

  def set_tran_types_for_frontend
    tran_types = {}

    TransactionType.all.each do |tt|
      next if tt.id == TransactionType::INITIALIZE_ID

      sources = tt.source_category.active_accounts.map { |x| { id: x.id, name: x.name } }
      targets = tt.target_category.active_accounts.map { |x| { id: x.id, name: x.name } }
      tran_types[tt.id] = { sources: sources, targets: targets }
    end

    gon.tran_types = tran_types
    gon.transaction = @transaction
  end
end

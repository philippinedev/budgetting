# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show edit update destroy]

  def index
    @transactions = Transaction.tran.order(created_at: :desc)
    @last_tran = Summary.last&.tran
  end

  def new
    set_draft
    authorize! :transaction, to: :create? unless { draft: false }
    @transaction = Transaction.new
    set_tran_types_for_frontend
  end

  def edit
    authorize! :transaction, to: :update? if @transaction.actualized?
    set_tran_types_for_frontend
  rescue ActionPolicy::Unauthorized
    redirect_to transactions_path, alert: policy_alert
  end

  def create
    set_draft
    authorize! :transaction, to: :create? unless { draft: false }

    ActiveRecord::Base.transaction do
      @transaction = Transaction.new(transaction_params)
      @transaction.created_by = current_user
      @transaction.updated_by = current_user

      if @transaction.transaction_type&.expense_category_id?
        @transaction.expense_account = @transaction.transaction_type.expense_category
        @transaction.fee = @transaction.transaction_type.expense_category.transaction_fee
      end
      
      if @transaction.save

        if @transaction.actualized?
          notice = "#{@transaction.actualized? ? '' : 'Draft'} Transaction was successfully created."
          source_amount = @transaction.summary.values[@transaction.source_account.code.downcase]
          raise NotEnoughSource.new "Insufficient funds on source account" if source_amount.negative?
          redirect_to root_path, notice: notice

        else
          redirect_to transactions_path, notice: notice
        end
        
      else
        set_tran_types_for_frontend
        render :new, status: :unprocessable_entity
      end
    end
    
  rescue ActionPolicy::Unauthorized
    redirect_to transactions_path, alert: policy_alert

  rescue NotEnoughSource => error
    set_tran_types_for_frontend
    @transaction.errors.add(:source_account_id, "cannot cover target amount") 
    render :edit, status: :unprocessable_entity

  end

  def show; end

  def update
    set_tran_types_for_frontend
    raise 'Cannot update an actualized transaction!' if already_actualized?

    respond_to do |format|
      @transaction.updated_by = current_user
      if @transaction.update(transaction_params)
        notice = "#{@transaction.actualized? ? '' : 'Draft'} Transaction was successfully updated."

        if @transaction.actualized?
          format.html { redirect_to root_path, notice: notice }
        else
          format.html { redirect_to transactions_path, notice: notice }
        end
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

  def set_draft
    @draft = params[:draft] \
      || (params[:transaction] && params[:transaction][:draft])
  end

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
    ).merge(is_draft: draft?)
  end

  def draft?
    if @transaction&.persisted?
      @transaction.draft?
    else
      !!ActiveModel::Type::Boolean.new.cast(params[:transaction][:draft])
    end
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    routing_error
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

  def policy_alert
    "You are not authorized to perform this action"
  end
end

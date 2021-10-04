# frozen_string_literal: true

class TransactionTypesController < ApplicationController
  before_action :set_type, only: [:destroy]

  def index
    @types = TransactionType.all
  end

  def new
    @type = TransactionType.new
  end

  def create
    authorize! :transaction_type, to: :create?
    @type = TransactionType.new(type_params)

    if @type.save
      redirect_to transaction_types_path, notice: 'Successfully created'
    else
      render :new
    end
  rescue ActionPolicy::Unauthorized
    redirect_to transaction_types_path, alert: "You are not authorized to perform this action"
  end

  def destroy
    @type.delete
    redirect_to transaction_types_path, notice: 'Successfully deleted'
  rescue ActiveRecord::InvalidForeignKey
    redirect_to transaction_types_path, alert: 'Failed to delete'
  end

  private

  def type_params
    params
      .require(:transaction_type)
      .permit(:name, :description, :source_category_id, :target_category_id, :mode)
  end

  def set_type
    @type = TransactionType.find(params[:id])
  end
end

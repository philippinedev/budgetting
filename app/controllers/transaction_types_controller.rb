class TransactionTypesController < ApplicationController

  def index
    @types = TransactionType.all
  end

  def new
    @type = TransactionType.new
  end

  def create
    @type = TransactionType.new(type_params)
    if @type.save
      redirect_to transaction_types_path, notice: "Successfully created"
    else
      render :new
    end
  end

  private

  def type_params
    params.require(:transaction_type).permit(:name, :description, :flow)
  end

end

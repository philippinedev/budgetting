class EntitiesController < ApplicationController
  def index
    @entities = Entity.all
  end

  def new
    @parent = Entity.find(params[:parent_id])
    @entity = @parent.entities.new
  end

  def show
    @entity = Entity.find(params[:id])
  end

  def create
    @parent = Entity.find(params[:entity][:parent_id])
    @entity = @parent.entities.new(entity_params)

    if @entity.save
      redirect_to entities_path, notice: "Entity was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @entity = Entity.find(params[:id])

    if @entity.destroy
      redirect_to entities_path, notice: "Entity was successfully deleted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def entity_params
    params.require(:entity)
          .permit(:name, :description)
  end
end

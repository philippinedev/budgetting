class EntitiesController < ApplicationController
  def index
    @entities = Entity.all
  end

  def new
    set_parent_and_entity
  end

  def show
    @entity = Entity.find(params[:id])
  end

  def create
    set_parent_and_entity(create: true)

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

  def set_parent_and_entity(create: false)
    set_parent
    set_entity(create)
  end

  def set_parent
    @parent = if params[:parent_id].present?
      Entity.find(params[:parent_id])

    elsif params[:entity] && params[:entity][:parent_id].present?
      Entity.find(params[:entity][:parent_id])

    else
      nil
    end
  end

  def set_entity(create)
    @entity = if create
      (@parent&.entities || Entity).new(entity_params)

    else
      (@parent&.entities || Entity).new
    end
  end

  def entity_params
    params.require(:entity)
          .permit(:name, :description)
  end
end

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
    if params[:parent_id].present?
      @parent = Entity.find(params[:parent_id])
    elsif params[:entity] && params[:entity][:parent_id].present?
      @parent = Entity.find(params[:entity][:parent_id])
    else
      @parent = nil
    end

    if create
      if @parent.present?
        @entity = @parent.entities.new(entity_params)
      else
        @entity = Entity.new(entity_params)
      end
    else
      if @parent.present?
        @entity = @parent.entities.new
      else
        @entity = Entity.new
      end
    end
  end

  def entity_params
    params.require(:entity)
          .permit(:name, :description)
  end
end

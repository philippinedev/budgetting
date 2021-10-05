# frozen_string_literal: true

class EntitiesController < ApplicationController
  before_action :set_entity, only: %i[show edit update destroy]

  def index
    @entities = Entity.all
  end

  def new
    set_parent_and_entity
  end

  def show
  end

  def edit
  end

  def create
    set_parent_and_entity(create: true)

    if @entity.save
      redirect_to entities_path, notice: 'Entity was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @entity.update(entity_params)
        format.html { redirect_to entities_path, notice: 'Entity was successfully updated' }
        format.json { render :show, status: :ok, location: @entity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

    if @entity.destroy
      redirect_to entities_path, notice: 'Entity was successfully deleted.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_entity
    @entity = Entity.find(params[:id])
  end

  def set_parent_and_entity(create: false)
    set_parent
    init_entity(create)
  end

  def set_parent
    @parent = if params[:parent_id].present?
                Entity.find(params[:parent_id])

              elsif params[:entity] && params[:entity][:parent_id].present?
                Entity.find(params[:entity][:parent_id])

              end
  end

  def init_entity(create_mode)
    @entity = if create_mode
                (@parent&.entities || Entity).new(entity_params)

              else
                (@parent&.entities || Entity).new
              end
  end

  def entity_params
    params.require(:entity)
          .permit(:name, :description, :transaction_fee)
  end
end

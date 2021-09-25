class SummariesController < ApplicationController
  def index
    @summaries = Summary.all
  end

  def show
    @summary = Summary.find(params[:id])
  end
end

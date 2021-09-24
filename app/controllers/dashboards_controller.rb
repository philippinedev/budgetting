class DashboardsController < ApplicationController
  def index
    @summary = Summary.last_data
  end
end

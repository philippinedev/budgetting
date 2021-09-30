class DashboardsController < ApplicationController
  def index
    @summary = Summary.last_data_with_updated
    @accounts = Entity.accounts.hashed_value
  end
end

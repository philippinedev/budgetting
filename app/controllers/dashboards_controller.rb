class DashboardsController < ApplicationController
  def index
    @summary = Summary.last_data_with_updated
    @accounts = Account.hash
  end
end

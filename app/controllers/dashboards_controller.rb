class DashboardsController < ApplicationController
  def index
    @root_accounts = Entity.roots
    @summary       = Summary.last_data_with_updated
    @accounts_code = Entity.hashed_value
  end
end

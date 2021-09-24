class DashboardsController < ApplicationController
  def index
    @summary = Summary.last_data
    a1 = Account.select(:id, :code, :description)
                       .map { |x| [ x.code, { id: x.id, description: x.description } ] }
    @accounts = Hash[*a1.flatten(1)]
  end
end

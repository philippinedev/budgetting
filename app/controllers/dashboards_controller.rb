class DashboardsController < ApplicationController
  def index
    @summary = Summary.last_data
    a1 = Account.select(:id, :code, :name)
                       .map { |x| [ x.code, { id: x.id, name: x.name } ] }
    @accounts = Hash[*a1.flatten(1)]
  end
end

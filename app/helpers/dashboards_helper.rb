module DashboardsHelper
  def code_to_name(code)
    Account.find_by(code: code)&.description
  end
end

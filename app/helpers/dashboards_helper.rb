module DashboardsHelper
  def row_class(value_hash)
    return '' unless value_hash[:updated]

    if value_hash[:is_account]
      value_hash[:increased_by] < 0 ? 'hilite-danger-primary' : 'hilite-primary'
    else
      value_hash[:increased_by] < 0 ? 'hilite-danger' : 'hilite'
    end
  end
end

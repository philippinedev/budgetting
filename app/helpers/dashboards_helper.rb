# frozen_string_literal: true

module DashboardsHelper
  def hilite(value_hash)
    return '' unless value_hash[:updated]
    return '' unless value_hash[:is_account]

    # if value_hash[:is_account]
    #   value_hash[:increased_by] < 0 ? 'hilite-danger-primary' : 'hilite-primary'
    # else
    #   value_hash[:increased_by] < 0 ? 'hilite-danger' : 'hilite'
    # end

    "hilite #{(value_hash[:increased_by]).negative? ? 'hilite-danger' : ''} hilite-bold"
  end
end

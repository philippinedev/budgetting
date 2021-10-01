module ApplicationHelper
  def from_cents(amount_cents, currency: 'PHP')
    I18n.locale = :en
    Money.from_cents(amount_cents, currency)
  end

  def selectable(data)
    data.pluck(:name, :id)
  end

  def titleized_enum(types)
    types.map { |x| [x[0].gsub(/_/, ' ').titleize, x[0]] }
  end
end

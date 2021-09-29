module ApplicationHelper
  def from_cents(amount_cents, currency: 'PHP')
    I18n.locale = :en
    Money.from_cents(amount_cents, currency)
  end

  def selectable(data)
    data.pluck(:name, :id)
  end
end

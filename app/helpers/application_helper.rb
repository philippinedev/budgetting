module ApplicationHelper
  def from_cents(amount_cents, currency: 'PHP')
    I18n.locale = :en
    Money.from_cents(amount_cents, currency)
  end
end

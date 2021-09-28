module ApplicationHelper
  def from_cents(amount_cents, currency: 'PHP')
    Money.from_cents(amount_cents, currency)
  end
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def to_cent(amount)
      (amount.to_f * 10000).to_i
    end

    def to_decimal(amount)
      amount.to_f / 10000.0
    end
  end
end

class Account < ApplicationRecord
  validates :description, presence: true, uniqueness: true

  before_save :set_code
  after_save :initialize_account

  private

  def set_code
    10.times do |num|
      self.code = description.split.map(&:first).join.upcase + (num == 0 ? '' : num.to_s)
      break unless Account.find_by(code: code)
    end
  end

  def initialize_account
    Transaction.initialize_account!(self)
  end
end

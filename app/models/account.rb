class Account < ApplicationRecord
  belongs_to :account_type, optional: true

  validates :description, presence: true, uniqueness: true

  before_save :set_code
  after_save :initialize_account

  def deactivate!
    touch(:deactivated_at)
  end

  def activate!
    update(deactivated_at: nil)
  end

  def deactivated?
    deactivated_at.present?
  end

  scope :active, -> { Account.where(deactivated_at: nil) }

  private

  def set_code
    return if persisted?

    10.times do |num|
      self.code = description
        .gsub(/[\(\)]/, "")
        .split.map(&:first)
        .join.upcase + (num == 0 ? '' : num.to_s)

      break unless Account.find_by(code: code)
    end
  end

  def initialize_account
    Transaction.initialize_account!(self)
  end
end

class Account < ApplicationRecord
  belongs_to :account_type, optional: true

  scope :employees, -> { joins(:account_type).where(account_types: { name: AccountType::EMPLOYEE }) }
  scope :employers, -> { joins(:account_type).where(account_types: { name: AccountType::EMPLOYER }) }
  scope :bank_accounts, -> { joins(:account_type).where(account_types: { name: AccountType::BANK_ACCOUNT }) }
  scope :salary_sources, -> { joins(:account_type).where(account_types: { name: [AccountType::BANK_ACCOUNT, AccountType::CASH] }) }
  scope :active, -> { where(deactivated_at: nil) }

  scope :expenses, -> { joins(:account_type).where(account_types: { name: AccountType::EXPENSES }) }

  validates :name, presence: true, uniqueness: true

  before_save :set_code
  after_save :initialize_account

  class << self
    def hashed_value
      a1 = active.select(:id, :code, :name)
                 .map { |x| [ x.code, { id: x.id, name: x.name } ] }
      Hash[*a1.flatten(1)]
    end
  end

  def deactivate!
    touch(:deactivated_at)
  end

  def activate!
    update(deactivated_at: nil)
  end

  def deactivated?
    deactivated_at.present?
  end

  private

  def set_code
    return if persisted?

    10.times do |num|
      name_parts = name.upcase.gsub(/[\(\)]/, "").split

      self.code = name_parts
        .map(&:first)
        .join + (num == 0 ? '' : num.to_s)

      if code.length == 1
        self.code += name_parts.last[1..2]
      elsif code.length == 2
        self.code += name_parts.last[1]
      end

      break unless Account.find_by(code: code)
    end
  end

  def initialize_account
    Transaction.initialize_account!(self)
  end
end

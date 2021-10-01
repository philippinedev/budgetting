class Entity < ApplicationRecord
  CASH = 19
  BANK = 18

  has_many :entities, class_name: 'Entity', foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: 'Entity', foreign_key: :parent_id, optional: true

  before_save :set_code
  after_save :set_parent_as_parent
  after_destroy :update_parent_as_parent

  scope :categories, -> { where(is_parent: true) }
  scope :accounts, -> { where(is_parent: false) }
  scope :active, -> { where(deactivated_at: nil) }

  validates :name, presence: true

  class << self
    def hashed_value
      a1 = active.select(:id, :code, :name)
                 .map { |x| [ x.code, { id: x.id, name: x.name } ] }
      Hash[*a1.flatten(1)]
    end
  end

  def accounts
    return [self] if account?

    entities.map { |entity| entity.accounts }.flatten
  end

  def name_more
    (account? ? "(ACCT) " : "(CAT) ") + name
  end

  def name_acct
    (account? ? "(ACCT) " : "") + name
  end

  def account?
    is_parent.blank?
  end

  def deactivated?
    deactivated_at.present?
  end

  def initialized?
    return false if Summary.count == 0

    Summary.last_data.has_key? code
  end

  def init!
    transaction_type = TransactionType.account_initializer

    source_account = Entity.find(self.id == CASH ? BANK : CASH)

    tran = Transaction.new
    tran.transaction_type = transaction_type
    tran.source_account = source_account
    tran.target_account = self
    tran.amount_cents = 0
    tran.actualized_at = DateTime.current
    tran.save!
  end

  private

  def set_code
    return if persisted?

    (1..100).to_a.each do |num|
      name_parts = name.upcase.gsub(/[\(\)]/, "").split

      self.code = name_parts.map(&:first).join

      if code.length == 1
        self.code += name_parts.last[1..2]
      elsif code.length == 2
        self.code += name_parts.last[1]
      end

      self.code += (num == 1 ? '' : num.to_s)

      break unless self.class.find_by(code: code)
    end
  end

  def set_parent_as_parent
    parent&.update(is_parent: true)
  end

  def update_parent_as_parent
    parent&.update(is_parent: parent.entities.any?)
  end
end

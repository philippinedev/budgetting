class Entity < ApplicationRecord
  CASH = 19
  BANK = 18
  TRANSACTION_CHARGES_ID = 100

  attr_reader :value

  has_many :entities, class_name: 'Entity', foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: 'Entity', foreign_key: :parent_id, optional: true

  before_save :set_code
  after_save :set_parent_as_parent
  after_create :auto_initialize
  after_destroy :update_parent_as_parent

  scope :categories,  -> { where(is_parent: true) }
  scope :accounts,    -> { where(is_parent: false) }
  scope :active,      -> { where(deactivated_at: nil) }
  scope :deactivated, -> { where.not(deactivated_at: nil) }
  scope :roots,       -> { where(parent_id: nil) }
  scope :transaction_charges, -> { where(parent_id: TRANSACTION_CHARGES_ID) }

  validates :name, presence: true

  class << self
    def hashed_value
      a1 = active.select(:id, :code, :name)
                 .map { |x| [ x.code, { id: x.id, name: x.name } ] }
      Hash[*a1.flatten(1)]
    end
  end

  def value
    @value ||= Summary.last_data[code]
  end

  def type
    return 'root'    if root?
    return 'parent'  if parent? || parent.root?
    'account'
  end

  def amount_cents
    amount * 100
  end

  def accounts
    return [self] if account?

    entities.map { |entity| entity.accounts }.flatten
  end

  def active_accounts
    return [self] if account?

    entities.active.map { |entity| entity.accounts }.flatten
  end

  def name_more
    (account? ? "(ACCT) " : "(CAT) ") + name
  end

  def name_acct
    (account? ? "(ACCT) " : "") + name
  end

  def root?
    parent_id.nil?
  end

  def account?
    is_parent.blank?
  end

  def parent?
    is_parent.present?
  end

  def deactivated?
    deactivated_at.present?
  end

  def initialized?
    return false if Summary.count == 0

    Summary.last_data.has_key? code
  end

  def deactivate!
    touch(:deactivated_at)
  end

  def activate!
    update(deactivated_at: nil)
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

  def auto_initialize
    Transaction.init!(self)
  end

  def set_parent_as_parent
    parent&.update(is_parent: true)
  end

  def update_parent_as_parent
    parent&.update(is_parent: parent.entities.any?)
  end
end

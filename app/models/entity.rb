class Entity < ApplicationRecord
  has_many :entities, class_name: 'Entity', foreign_key: :parent_id
  belongs_to :parent, class_name: 'Entity', foreign_key: :parent_id, optional: true

  before_save :set_code
  after_save :set_parent_as_parent
  after_destroy :update_parent_as_parent

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

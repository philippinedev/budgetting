class TransactionPolicy < ApplicationPolicy
  def create?
    if { draft: false }
      user.admin?
    end
  end

  def update?
    if { draft: false }
      false
    elsif { draft: true }
      true
    end
  end

  def destroy?
    if { draft: false }
      user.admin?
    end
  end

  def view?
    user.admin?
  end

  # See https://actionpolicy.evilmartians.io/#/writing_policies
  #
  # def index?
  #   true
  # end
  #
  # def update?
  #   # here we can access our context and record
  #   user.admin? || (user.id == record.user_id)
  # end

  # Scoping
  # See https://actionpolicy.evilmartians.io/#/scoping
  #
  # relation_scope do |relation|
  #   next relation if user.admin?
  #   relation.where(user: user)
  # end
end

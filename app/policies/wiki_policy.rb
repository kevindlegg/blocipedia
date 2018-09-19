class WikiPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.present? && (user.admin? || user.premium?)
        scope.all
      else
        scope.where(private: false).or(scope.where(user: user))
      end
    end
  end

  def new 
    create?
  end

  def create?
    user.present?
  end

  def edit?
    update?
  end

  def update?
    return true if user.present? && (user.admin? || record.user == user)
  end

  def destroy?
    return true if user.present? && (user.admin? || record.user == user)
  end

  def show?
    return true if user.present? && (user.admin? || user.premium? || record.user == user || !record.private)
  end

end

class WikiPolicy < ApplicationPolicy

  def new 
    user.present?
  end

  def create?
    user.present? && (!record.private || (record.private && user.admin? || user.premium?))
  end

  def edit?
    update?
  end

  def update?
    return true if user.present? && (user.admin? || record.user == user || record.collaborators.where(user: user).exists?)
  end

  def destroy?
    return true if user.present? && (user.admin? || record.user == user)
  end

  def show?
    return true if user.present? && (user.admin? || user.premium? || record.user == user || record.private == false || record.collaborators.where(user: user).exists?)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []
      if user.role == 'admin'
        wikis = scope.all # if the user is an admin, show them all the wikis
      elsif user.role == 'premium'
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.user == user || wiki.collaborators.where(user: user).exists?
            wikis << wiki 
          end
        end
      else # this is the lowly standard user
        all_wikis = scope.all
        wikis = []
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.collaborators.where(user: user).exists?
            wikis << wiki # only show standard users public wikis and private wikis they are a collaborator on
          end
        end
      end
      wikis # return the wikis array we've built up
    end
  end
end

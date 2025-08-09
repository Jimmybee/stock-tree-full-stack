class TeamPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  class Scope < Scope
    def resolve
      scope.joins(:teams_users).where(teams_users: { user_id: user.id })
    end
  end
end

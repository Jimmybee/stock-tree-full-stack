class FolderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(team: :teams_users).where(teams_users: { user_id: user.id })
    end
  end
end

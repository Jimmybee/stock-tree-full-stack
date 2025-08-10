class TagPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(team: :teams_users).where(teams_users: { user_id: user.id })
    end
  end

  def show?
    in_scope?
  end

  def create?
    return false if record.team_id.blank?
    Team.joins(:teams_users).where(id: record.team_id, teams_users: { user_id: user.id }).exists?
  end

  def update?
    in_scope?
  end

  def destroy?
    in_scope?
  end

  private

  def in_scope?
    Scope.new(user, Tag).resolve.where(id: record.id).exists?
  end
end

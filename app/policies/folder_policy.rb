class FolderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(team: :teams_users).where(teams_users: { user_id: user.id })
    end
  end

  def show?
    in_team?
  end

  def create?
    in_team_for_record?
  end

  def update?
    in_team?
  end

  def destroy?
    in_team?
  end

  private

  def in_team?
    Scope.new(user, Folder).resolve.where(id: record.id).exists?
  end

  def in_team_for_record?
    # When creating a new folder, record.team_id must be accessible to the user
    return false if record.team_id.blank?
    Team.joins(:teams_users).where(id: record.team_id, teams_users: { user_id: user.id }).exists?
  end
end

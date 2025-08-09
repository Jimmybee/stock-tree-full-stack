class Api::V1::TeamsController < ApplicationController
  before_action :authenticate_user!

  def index
    teams = current_user.teams.order(:name)
    render json: { teams: teams.as_json(only: %i[id name]) }
  end

  def create
    team = Team.new(team_params)
    if team.save
      TeamsUser.create!(team: team, user: current_user)
      Folders::CreateRoot.call(team)
      render json: { team: team.as_json(only: %i[id name]) }, status: :created
    else
      render json: { errors: team.errors.map { |e| { field: e.attribute, message: e.message } } }, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end

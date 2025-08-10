class Api::V1::TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:top_folder]

  def index
  teams = policy_scope(Team).order(:name)
  render json: { teams: teams.as_json(only: %i[id name]) }
  end

  def create
  team = Team.new(team_params)
  authorize team
  if team.save
    TeamsUser.create!(team: team, user: current_user)
    Folders::CreateRoot.call(team)
    render json: { team: team.as_json(only: %i[id name]) }, status: :created
  else
    err = team.errors.map { |e| { field: e.attribute, message: e.message } }
    render json: { errors: err }, status: :unprocessable_entity
  end
  end

  def top_folder
    authorize @team, :index?
  @folder = @team.folders.includes(:subfolders, :products).find_by!(parent_id: nil)
  render json: { folder: FolderSerializer.new(@folder).serializable_hash[:data][:attributes].merge(id: @folder.id) }
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def set_team
    @team = policy_scope(Team).find(params[:id])
  end
end

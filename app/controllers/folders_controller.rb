class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_folder, only: :show

  def team_root
    @team = policy_scope(Team).find(params[:id])
    authorize @team, :index?
    @folder = @team.folders.includes(:subfolders, :products).find_by!(parent_id: nil)
    render :show
  end

  def show
    authorize @folder
  end

  private

  def set_folder
    @folder = policy_scope(Folder).includes(:subfolders, :products).find(params[:id])
  end
end

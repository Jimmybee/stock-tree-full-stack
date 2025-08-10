class Api::V1::FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_folder, only: [:show, :update, :destroy]

  def index
    # Optional team scoping via team_id
  folders = policy_scope(Folder).includes(:subfolders, :products)
    folders = folders.where(team_id: params[:team_id]) if params[:team_id].present?
    @folders = folders.order(:name)
    render json: { folders: @folders.map { |f| FolderSerializer.new(f).serializable_hash[:data][:attributes].merge(id: f.id) } }
  end

  def show
    authorize @folder
  @folder = Folder.includes(:subfolders, :products).find(@folder.id)
  render json: { folder: FolderSerializer.new(@folder).serializable_hash[:data][:attributes].merge(id: @folder.id) }
  end

  def create
    @folder = Folder.new(folder_params)
    authorize @folder
    if @folder.save
      render json: { folder: FolderSerializer.new(@folder).serializable_hash[:data][:attributes].merge(id: @folder.id) }, status: :created
    else
      render json: { errors: build_errors(@folder) }, status: :unprocessable_entity
    end
  end

  def update
    authorize @folder
    if @folder.update(folder_params)
      render json: { folder: FolderSerializer.new(@folder).serializable_hash[:data][:attributes].merge(id: @folder.id) }
    else
      render json: { errors: build_errors(@folder) }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @folder
    @folder.destroy
    render json: { ok: true }
  end

  private

  def set_folder
    @folder = policy_scope(Folder).find(params[:id])
  end

  def folder_params
    params.require(:folder).permit(:team_id, :parent_id, :name)
  end

  def build_errors(record)
    record.errors.map { |e| { field: e.attribute, message: e.message } }
  end
end

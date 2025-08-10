class Api::V1::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: [:show, :update, :destroy]

  def index
    tags = policy_scope(Tag)
    tags = tags.where(team_id: params[:team_id]) if params[:team_id].present?
    render json: { tags: tags.order(:name).map { |t| TagSerializer.new(t).serializable_hash[:data][:attributes].merge(id: t.id) } }
  end

  def show
    authorize @tag
    render json: { tag: TagSerializer.new(@tag).serializable_hash[:data][:attributes].merge(id: @tag.id) }
  end

  def create
    @tag = Tag.new(tag_params)
    authorize @tag
    if @tag.save
      render json: { tag: TagSerializer.new(@tag).serializable_hash[:data][:attributes].merge(id: @tag.id) }, status: :created
    else
      render json: { errors: build_errors(@tag) }, status: :unprocessable_entity
    end
  end

  def update
    authorize @tag
    if @tag.update(tag_params)
      render json: { tag: TagSerializer.new(@tag).serializable_hash[:data][:attributes].merge(id: @tag.id) }
    else
      render json: { errors: build_errors(@tag) }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @tag
    @tag.destroy
    render json: { ok: true }
  end

  private

  def set_tag
    @tag = policy_scope(Tag).find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:team_id, :name)
  end

  def build_errors(record)
    record.errors.map { |e| { field: e.attribute, message: e.message } }
  end
end

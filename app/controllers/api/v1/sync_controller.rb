class Api::V1::SyncController < ApplicationController
  before_action :authenticate_user!

  # POST /api/v1/sync
  # { team_id, last_sync_time, products: [...] }
  def create
    team = policy_scope(Team).find(params[:team_id])
    authorize team, :index?

    last_sync_time = parse_time(params[:last_sync_time])

    result = Sync::ProductsUpsert.call(
      team: team,
      products: params[:products] || [],
      current_user: current_user
    )

    updated = team.products.where('updated_at > ?', last_sync_time).includes(:folder, :tags)

    render json: {
      upserted_count: result[:upserted_count],
      products: updated.map { |p| ProductSerializer.new(p).serializable_hash[:data][:attributes].merge(id: p.id) }
    }
  rescue ActiveRecord::RecordNotFound
    render json: { errors: [{ field: :team_id, message: 'not found or not accessible' }] }, status: :not_found
  rescue ArgumentError => e
    render json: { errors: [{ field: :last_sync_time, message: e.message }] }, status: :unprocessable_entity
  end

  private

  def parse_time(str)
    return Time.at(0).utc if str.blank?
    Time.iso8601(str)
  rescue ArgumentError
    raise ArgumentError, 'invalid ISO-8601 timestamp'
  end
end

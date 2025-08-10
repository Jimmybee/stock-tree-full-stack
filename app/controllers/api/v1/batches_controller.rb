class Api::V1::BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product
  before_action :set_batch, only: [:update, :destroy]

  def index
    authorize @product, :show?
    batches = @product.batches.includes(:folder).order(:expiry_date)
    render json: { batches: batches.map { |b| BatchSerializer.new(b).serializable_hash[:data][:attributes].merge(id: b.id) } }
  end

  def create
    batch = @product.batches.build(batch_params)
    authorize batch
    if batch.save
      render json: { batch: BatchSerializer.new(batch).serializable_hash[:data][:attributes].merge(id: batch.id) }, status: :created
    else
      render json: { errors: build_errors(batch) }, status: :unprocessable_entity
    end
  end

  def update
    authorize @batch
    if @batch.update(batch_params)
      render json: { batch: BatchSerializer.new(@batch).serializable_hash[:data][:attributes].merge(id: @batch.id) }
    else
      render json: { errors: build_errors(@batch) }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @batch
    @batch.destroy
    render json: { ok: true }
  end

  private

  def set_product
    @product = policy_scope(Product).find(params[:product_id])
  end

  def set_batch
    @batch = @product.batches.find(params[:id])
  end

  def batch_params
    params.require(:batch).permit(:folder_id, :qty, :expiry_date, :lot_code)
  end

  def build_errors(record)
    record.errors.map { |e| { field: e.attribute, message: e.message } }
  end
end

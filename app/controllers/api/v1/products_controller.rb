class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    products = policy_scope(Product)
    products = products.where(team_id: params[:team_id]) if params[:team_id].present?
    products = products.where(folder_id: params[:folder_id]) if params[:folder_id].present?
    if params[:tag_ids].present?
      tag_ids = Array(params[:tag_ids])
      products = products.joins(:tags).where(tags: { id: tag_ids })
    end
    if params[:q].present?
      q = "%#{params[:q]}%"
      products = products.where('products.name ILIKE ? OR products.bar_code ILIKE ?', q, q)
    end
    products = products.includes(:team, :folder, :tags, product_image_attachment: :blob).distinct
    @pagy, @products = pagy(products.order(updated_at: :desc))
    render json: {
      products: @products.map { |p| ProductSerializer.new(p).serializable_hash[:data][:attributes].merge(id: p.id) },
      meta: { pagy: { count: @pagy.count, page: @pagy.page, pages: @pagy.pages, items: @pagy.vars[:items] } }
    }
  end

  def show
    authorize @product
    render json: { product: ProductSerializer.new(@product).serializable_hash[:data][:attributes].merge(id: @product.id) }
  end

  def create
    @product = Product.new(product_params)
    authorize @product
    attach_image(@product)
    if @product.save
      render json: { product: ProductSerializer.new(@product).serializable_hash[:data][:attributes].merge(id: @product.id) }, status: :created
    else
      render json: { errors: build_errors(@product) }, status: :unprocessable_entity
    end
  end

  def update
    authorize @product
    attach_image(@product)
    if @product.update(product_params)
      render json: { product: ProductSerializer.new(@product).serializable_hash[:data][:attributes].merge(id: @product.id) }
    else
      render json: { errors: build_errors(@product) }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @product
    @product.destroy
    render json: { ok: true }
  end

  private

  def set_product
    @product = policy_scope(Product).find(params[:id])
  end

  def product_params
  params.require(:product).permit(:team_id, :folder_id, :name, :description, :qty, :bar_code, :price_in_minor_unit, :min_level, :batched, tag_ids: [], custom_field_data: {})
  end

  def attach_image(product)
    return unless params[:product_image].present?
    product.product_image.attach(params[:product_image])
  end

  def build_errors(record)
    record.errors.map { |e| { field: e.attribute, message: e.message } }
  end
end

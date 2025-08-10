class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :update]

  def index
  products = policy_scope(Product)
    products = products.where(folder_id: params[:folder_id]) if params[:folder_id].present?
    products = products.joins(:tags).where(tags: { id: params[:tag_ids] }) if params[:tag_ids].present?
    if params[:q].present?
      q = "%#{params[:q]}%"
      products = products.where('products.name ILIKE ? OR products.bar_code ILIKE ?', q, q)
    end
    if params[:min_level].present?
      products = products.where('min_level >= ?', params[:min_level].to_i)
    end
    products = products.includes(:folder, :tags, product_image_attachment: :blob).distinct.order(updated_at: :desc)

    @pagy, @products = pagy(products)

  # For filters UI
  @root_folders = policy_scope(Folder).where(parent_id: nil).includes(:subfolders)
  @available_tags = policy_scope(Tag).order(:name)
  end

  def new
    @product = Product.new
    # Optional prefill from params
    @product.team_id = params[:team_id] if params[:team_id]
    @product.folder_id = params[:folder_id] if params[:folder_id]
    authorize @product
  @available_tags = policy_scope(Tag).where(team_id: @product.team_id).order(:name) if @product.team_id
  end

  def create
    @product = Product.new(product_params)
    authorize @product
    if @product.save
      redirect_to @product, notice: 'Product created'
    else
      @available_tags = policy_scope(Tag).where(team_id: @product.team_id).order(:name) if @product.team_id
      flash.now[:alert] = @product.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def show
    authorize @product
    @batches = @product.batches.order(:expiry_date)
    @available_tags = policy_scope(Tag).where(team_id: @product.team_id).order(:name)
  end

  def update
    authorize @product
    if @product.update(product_params)
      redirect_to @product, notice: 'Updated'
    else
      @batches = @product.batches.order(:expiry_date)
      @available_tags = policy_scope(Tag).where(team_id: @product.team_id).order(:name)
      flash.now[:alert] = @product.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = policy_scope(Product).find(params[:id])
  end

  def product_params
  params.require(:product).permit(:team_id, :folder_id, :name, :description, :qty, :bar_code, :price_in_minor_unit, :min_level, :batched, :product_image, tag_ids: [])
  end
end

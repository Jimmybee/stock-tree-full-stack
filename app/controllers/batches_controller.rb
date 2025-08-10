class BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product

  def create
    batch = @product.batches.build(batch_params)
    authorize batch
    if batch.save
      redirect_to @product, notice: 'Batch added'
    else
      redirect_to @product, alert: batch.errors.full_messages.to_sentence
    end
  end

  def destroy
    batch = @product.batches.find(params[:id])
    authorize batch
    batch.destroy
    redirect_to @product, notice: 'Batch removed'
  end

  private

  def set_product
    @product = policy_scope(Product).find(params[:product_id])
  end

  def batch_params
    params.require(:batch).permit(:folder_id, :qty, :expiry_date, :lot_code)
  end
end

# == Schema Information
#
# Table name: products
#
#  id                  :uuid             not null, primary key
#  team_id             :uuid             not null
#  folder_id           :uuid
#  name                :string           not null
#  description         :text
#  qty                 :integer          default(0), not null
#  bar_code            :string
#  price_in_minor_unit :integer
#  min_level           :integer
#  custom_field_data   :jsonb            not null
#  batched             :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Product < ApplicationRecord
  belongs_to :team
  belongs_to :folder, optional: true

  has_one_attached :product_image
  has_and_belongs_to_many :tags, join_table: :products_tags
  has_many :batches, dependent: :destroy

  validates :name, presence: true
  validates :price_in_minor_unit, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :validate_product_image

  private

  def validate_product_image
    return unless product_image.attached?

    if !product_image.content_type.in?(%w[image/png image/jpeg image/jpg image/webp])
      errors.add(:product_image, 'must be a PNG, JPG, or WEBP image')
    end

    if product_image.byte_size > 5.megabytes
      errors.add(:product_image, 'size must be less than 5MB')
    end
  end
end

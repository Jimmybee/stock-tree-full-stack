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
class ProductSerializer
  include JSONAPI::Serializer

  set_type :product
  set_id :id

  attributes :team_id, :folder_id, :name, :description, :qty, :bar_code, :price_in_minor_unit, :min_level, :batched, :custom_field_data

  attribute :product_image_url do |product|
    if product.product_image.attached?
      Rails.application.routes.url_helpers.url_for(product.product_image)
    end
  end

  attribute :tags do |product|
    product.tags.select(:id, :name).map { |t| { id: t.id, name: t.name } }
  end
end

json.extract! product, :id, :team_id, :folder_id, :name, :description, :qty, :bar_code, :price_in_minor_unit, :min_level, :batched
json.custom_field_data product.custom_field_data
json.product_image_url product.product_image.attached? ? url_for(product.product_image) : nil
json.tags product.tags.select(:id, :name).map { |t| { id: t.id, name: t.name } }

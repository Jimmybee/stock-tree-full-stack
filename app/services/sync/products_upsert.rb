module Sync
  class ProductsUpsert
    def self.call(team:, products:, current_user:)
      new(team:, products:, current_user:).call
    end

    def initialize(team:, products:, current_user:)
      @team = team
      @products = products
      @current_user = current_user
    end

    def call
      upserted = 0
      ApplicationRecord.transaction do
        @products.each do |payload|
          payload = payload.to_unsafe_h if payload.respond_to?(:to_unsafe_h)
          payload = payload.to_h if payload.respond_to?(:to_h) && !payload.is_a?(Hash)
          next unless payload.is_a?(Hash)
          attrs = permitted_attrs(payload)
          next if attrs.nil?

          if attrs[:id].present?
            product = @team.products.find_by(id: attrs[:id])
            if product
              product.assign_attributes(attrs.except(:id))
              upserted += 1 if product.changed? && product.save!
            else
              # If id provided but not found in this team, ignore to avoid cross-team
              next
            end
          else
            @team.products.create!(attrs)
            upserted += 1
          end
        end
      end
      { upserted_count: upserted }
    end

    private

    def permitted_attrs(payload)
      allowed = %w[id folder_id name description qty bar_code price_in_minor_unit min_level batched custom_field_data]
      attrs = payload.slice(*allowed)
  attrs = attrs.symbolize_keys
      # ensure qty non-negative
      if attrs[:qty]
        q = attrs[:qty].to_i
        return nil if q < 0
        attrs[:qty] = q
      end
      attrs
    end
  end
end

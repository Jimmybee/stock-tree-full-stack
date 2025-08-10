# == Schema Information
#
# Table name: batches
#
#  id          :uuid             not null, primary key
#  product_id  :uuid             not null
#  folder_id   :uuid             not null
#  qty         :integer          default(0), not null
#  expiry_date :date
#  lot_code    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Batch < ApplicationRecord
  belongs_to :product
  belongs_to :folder

  validates :qty, numericality: { greater_than_or_equal_to: 0 }
  validate :team_consistency

  private

  def team_consistency
    return if product.nil? || folder.nil?
    if product.team_id != folder.team_id
      errors.add(:base, 'Product and Folder must belong to the same team')
    end
  end
end

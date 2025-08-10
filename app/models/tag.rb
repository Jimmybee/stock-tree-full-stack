# == Schema Information
#
# Table name: tags
#
#  id         :uuid             not null, primary key
#  team_id    :uuid             not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  belongs_to :team
  has_and_belongs_to_many :products, join_table: :products_tags

  validates :name, presence: true
  validates :name, uniqueness: { scope: :team_id }
end

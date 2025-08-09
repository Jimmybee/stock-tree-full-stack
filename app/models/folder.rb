# == Schema Information
#
# Table name: folders
#
#  id         :uuid             not null, primary key
#  team_id    :uuid             not null
#  parent_id  :uuid
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Folder < ApplicationRecord
  belongs_to :team
  belongs_to :parent, class_name: 'Folder', optional: true
  has_many :subfolders, class_name: 'Folder', foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy

  validates :name, presence: true
end

# == Schema Information
#
# Table name: teams
#
#  id            :uuid             not null, primary key
#  name          :string           not null
#  custom_fields :jsonb            not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Team < ApplicationRecord
  has_many :teams_users, dependent: :destroy
  has_many :users, through: :teams_users
  has_many :folders, dependent: :destroy
  has_many :products, dependent: :destroy

  validates :name, presence: true
end

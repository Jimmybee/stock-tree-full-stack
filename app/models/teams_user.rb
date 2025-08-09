# == Schema Information
#
# Table name: teams_users
#
#  id         :uuid             not null, primary key
#  team_id    :uuid             not null
#  user_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TeamsUser < ApplicationRecord
  self.table_name = 'teams_users'

  belongs_to :team
  belongs_to :user

  validates :team_id, uniqueness: { scope: :user_id }
end

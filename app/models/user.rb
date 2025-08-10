# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  jti                    :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#
class User < ApplicationRecord
  has_many :teams_users, dependent: :destroy
  has_many :teams, through: :teams_users
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  after_create :ensure_personal_team

  private

  def ensure_personal_team
    # Create a default team for the user and link them; create root folder
    team_name = [first_name, last_name].compact_blank.join(' ').presence || email.split('@').first.capitalize
    team = Team.create!(name: team_name, custom_fields: {})
    TeamsUser.create!(team: team, user: self)
    Folders::CreateRoot.call(team)
  end
end

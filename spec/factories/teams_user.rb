# == Schema Information
#
# Table name: teams_users
#
#  id      :uuid             not null, primary key
#  team_id :uuid             not null
#  user_id :uuid             not null
#
FactoryBot.define do
  factory :teams_user do
    association :team
    association :user
  end
end

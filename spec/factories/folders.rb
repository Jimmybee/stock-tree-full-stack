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
FactoryBot.define do
  factory :folder do
    association :team
    name { Faker::Commerce.unique.department(max: 1) }
    parent { nil }
  end
end

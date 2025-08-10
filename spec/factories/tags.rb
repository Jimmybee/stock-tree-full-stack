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
FactoryBot.define do
  factory :tag do
    association :team
    name { Faker::Commerce.unique.material }
  end
end

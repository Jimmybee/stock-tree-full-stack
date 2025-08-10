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
FactoryBot.define do
  factory :team do
    name { Faker::Company.unique.name }
  end
end

# == Schema Information
#
# Table name: products
#
#  id                  :uuid             not null, primary key
#  team_id             :uuid             not null
#  folder_id           :uuid
#  name                :string           not null
#  description         :text
#  qty                 :integer          default(0), not null
#  bar_code            :string
#  price_in_minor_unit :integer
#  min_level           :integer
#  custom_field_data   :jsonb            not null
#  batched             :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :product do
    association :team
    association :folder, factory: :folder
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    qty { rand(0..100) }
    bar_code { Faker::Number.number(digits: 10) }
    price_in_minor_unit { rand(100..10_000) }
    min_level { rand(0..10) }
    batched { false }
    custom_field_data { {} }
  end
end

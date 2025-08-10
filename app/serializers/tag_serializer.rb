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
class TagSerializer
  include JSONAPI::Serializer
  set_type :tag
  set_id :id
  attributes :name, :team_id
end

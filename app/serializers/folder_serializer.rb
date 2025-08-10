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
class FolderSerializer
  include JSONAPI::Serializer

  set_type :folder
  set_id :id

  attributes :name, :parent_id, :team_id

  attribute :sub_folders do |folder|
    folder.subfolders.select(:id, :name).map { |f| { id: f.id, name: f.name } }
  end

  attribute :products do |folder|
    folder.products.select(:id, :name).map { |p| { id: p.id, name: p.name } }
  end
end

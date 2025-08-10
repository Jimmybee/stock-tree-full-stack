json.folders @folders do |folder|
  json.extract! folder, :id, :name, :parent_id, :team_id
end

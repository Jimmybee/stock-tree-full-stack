json.extract! folder, :id, :name, :parent_id
json.team_id folder.team_id
json.sub_folders folder.subfolders.map { |f| { id: f.id, name: f.name } }
json.products folder.products.limit(50).map { |p| { id: p.id, name: p.name } }

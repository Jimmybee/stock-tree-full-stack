module Folders
  class CreateRoot
    def self.call(team)
      team.folders.find_or_create_by!(name: 'Root', parent_id: nil)
    end
  end
end

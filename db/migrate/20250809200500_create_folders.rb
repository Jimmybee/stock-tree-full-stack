class CreateFolders < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :folders, id: :uuid do |t|
      t.uuid :team_id, null: false
      t.uuid :parent_id
      t.string :name, null: false
      t.timestamps
    end

    add_index :folders, :team_id
    add_index :folders, :parent_id
    add_foreign_key :folders, :teams, column: :team_id
    add_foreign_key :folders, :folders, column: :parent_id
  end
end

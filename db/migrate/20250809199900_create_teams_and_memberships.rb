class CreateTeamsAndMemberships < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :teams, id: :uuid do |t|
      t.string :name, null: false
      t.jsonb :custom_fields, null: false, default: {}
      t.timestamps
    end

    create_table :teams_users, id: :uuid do |t|
      t.uuid :team_id, null: false
      t.uuid :user_id, null: false
      t.timestamps
    end

    add_index :teams_users, [:team_id, :user_id], unique: true
    add_foreign_key :teams_users, :teams, column: :team_id
    add_foreign_key :teams_users, :users, column: :user_id
  end
end

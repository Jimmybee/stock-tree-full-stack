class AddPerfIndexes < ActiveRecord::Migration[7.1]
  def change
    add_index :products, :bar_code unless index_exists?(:products, :bar_code)
    add_index :products, :updated_at unless index_exists?(:products, :updated_at)
    add_index :folders, [:team_id, :parent_id] unless index_exists?(:folders, [:team_id, :parent_id])
    add_index :teams_users, [:user_id, :team_id], unique: true unless index_exists?(:teams_users, [:user_id, :team_id])
  end
end

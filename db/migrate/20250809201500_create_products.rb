class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products, id: :uuid do |t|
      t.uuid :team_id, null: false
      t.uuid :folder_id
      t.string :name, null: false
      t.text :description
      t.integer :qty, default: 0, null: false
      t.string :bar_code
      t.integer :price_in_minor_unit
      t.integer :min_level
      t.jsonb :custom_field_data, null: false, default: {}
      t.boolean :batched, null: false, default: false
      t.timestamps
    end
    add_index :products, :team_id
    add_index :products, :folder_id
    add_foreign_key :products, :teams
    add_foreign_key :products, :folders
  end
end

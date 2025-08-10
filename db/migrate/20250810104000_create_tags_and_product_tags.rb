class CreateTagsAndProductTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags, id: :uuid do |t|
      t.uuid :team_id, null: false
      t.string :name, null: false
      t.timestamps
    end
    add_index :tags, [:team_id, :name], unique: true
    add_foreign_key :tags, :teams

    create_table :products_tags, id: false do |t|
      t.uuid :product_id, null: false
      t.uuid :tag_id, null: false
    end
    add_index :products_tags, [:product_id, :tag_id], unique: true
    add_foreign_key :products_tags, :products
    add_foreign_key :products_tags, :tags
  end
end

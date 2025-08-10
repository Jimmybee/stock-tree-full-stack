class CreateBatches < ActiveRecord::Migration[7.1]
  def change
    create_table :batches, id: :uuid do |t|
      t.uuid :product_id, null: false
      t.uuid :folder_id, null: false
      t.integer :qty, null: false, default: 0
      t.date :expiry_date
      t.string :lot_code
      t.timestamps
    end
    add_index :batches, :product_id
    add_index :batches, :folder_id
    add_index :batches, :expiry_date
    add_foreign_key :batches, :products
    add_foreign_key :batches, :folders
  end
end

class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock
      t.string :category
      
      #audit fields
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.boolean :is_deleted, default: false, null: false

      t.timestamps
    end

    add_index :products, :is_deleted
    add_index :products, :deleted_at
    
  end
end

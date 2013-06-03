class Items < ActiveRecord::Migration
 
 
  ITEMS_TABLE_NAME          = :items

  def up
    create_table ITEMS_TABLE_NAME do |t|
      t.string :name
      t.decimal :price
      t.integer :sku
      t.string :active
      t.date :date_added
    end
  end

  def down
    drop_table ITEMS_TABLE_NAME
  end
end

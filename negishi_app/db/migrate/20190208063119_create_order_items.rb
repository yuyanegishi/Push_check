class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.integer :order_id, :null => false
      t.integer :book_id, :null => false
      t.integer :quantity, :null => false
      t.integer :purchase_price, :null => false

      t.timestamps
    end
    add_index :order_items, [:order_id, :book_id], unique: true
  end
end

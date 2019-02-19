class CreateCartItems < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_items do |t|
      t.integer :user_id, :null => false
      t.integer :book_id, :null => false
      t.integer :quantity, :null => false
      t.integer :planned_price, :null => false

      t.timestamps
    end
    add_index :cart_items, [:user_id, :book_id], unique: true
  end
end

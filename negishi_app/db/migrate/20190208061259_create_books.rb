class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title, :null => false
      t.string :author, :null => false
      t.text :overview
      t.string :picture, :null => false
      t.integer :price, :null => false
      t.integer :stock, :null => false

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE books
      ADD CONSTRAINT price
      CHECK (price >= 0);
    SQL

    execute <<-SQL
    ALTER TABLE books
      ADD CONSTRAINT stock
      CHECK (stock >= 0);
    SQL
  end
end

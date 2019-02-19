class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :consignee, :null => false
      t.integer :first_postal_code, :null => false
      t.integer :last_postal_code, :null => false
      t.string :first_address, :null => false
      t.string :second_address
      t.string :phone, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end

  end
end

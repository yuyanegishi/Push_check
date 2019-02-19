class AddIndexAddressesUserId < ActiveRecord::Migration[5.2]
  def change
    add_index :addresses, :user_id
  end
end

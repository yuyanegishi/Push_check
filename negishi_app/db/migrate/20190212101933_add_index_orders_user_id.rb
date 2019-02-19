class AddIndexOrdersUserId < ActiveRecord::Migration[5.2]
  def change
    add_index :orders, :user_id
  end
end

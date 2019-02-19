class AddSelectedAddressToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :selected_address, :integer
  end
end

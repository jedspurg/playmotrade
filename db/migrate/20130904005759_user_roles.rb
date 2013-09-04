class UserRoles < ActiveRecord::Migration
  def change
    add_column :users, :role, :string

    remove_column :users, :active
  end
end

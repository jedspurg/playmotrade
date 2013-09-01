class ChangeUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :password
  	remove_column :users, :language_preference
    remove_column :users, :timezone
  end
end

class AddMoreStoreSettings < ActiveRecord::Migration
  def change
    add_column :stores, :closed_message, :text
    add_column :stores, :bypass_password, :string
  end
end

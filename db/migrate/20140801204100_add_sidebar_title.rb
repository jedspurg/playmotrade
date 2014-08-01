class AddSidebarTitle < ActiveRecord::Migration
  def change
    add_column :stores, :sidebar_title, :string
  end
end

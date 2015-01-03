class ModifyPageRelations < ActiveRecord::Migration
  def change
    Page.delete_all

    remove_column :pages, :user_id
    add_column :pages, :store_id, :integer
  end
end

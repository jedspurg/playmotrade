class AddTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, :null => false
      t.timestamps
    end

    create_table :catalog_tags do |t|
      t.integer :tag_id, :null => false
      t.integer :catalog_item_id, :null => false
      t.timestamps
    end
  end
end

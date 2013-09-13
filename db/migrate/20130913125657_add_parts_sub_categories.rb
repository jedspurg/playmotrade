class AddPartsSubCategories < ActiveRecord::Migration
  def change
    
    create_table :catalog_parts_subcategories do |t|

      t.integer :catalog_parts_category_id
      t.string :name
      t.timestamps

    end

  end
end

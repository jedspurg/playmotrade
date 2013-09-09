class AddSets < ActiveRecord::Migration
  def change
    create_table :catalog_sets do |t|

      t.integer :part_count
      t.integer :figure_count
      t.attachment :back_image

    end
  end
end

class AddPageUploads < ActiveRecord::Migration
  def change
    create_table :page_uploads do |t|
      t.attachment :image
      t.timestamps
    end
  end
end

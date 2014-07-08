class AddPages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :user, :null => false
      t.string :title, :null => false
      t.string :slug, :null => false
      t.text :body, :null => false
      t.integer :page_category_id

      t.timestamps
    end

    create_table :page_categories do |t|
      t.string :name, :null => false

      t.timestamps
    end

    ['general', 'documentation', 'terms and service', 'blog'].each do |name|
      PageCategory.create(name: name)
    end
  end
end

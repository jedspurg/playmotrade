class AddThemeToSet < ActiveRecord::Migration
  def change
    add_column :catalog_sets, :theme, :string
    add_column :catalog_sets, :release_date, :integer
    add_column :catalog_sets, :retire_date, :integer
  end
end

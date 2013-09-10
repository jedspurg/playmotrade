class AddTimestampsToSets < ActiveRecord::Migration
  def change
    add_column :catalog_sets, :updated_at, :timestamp
    add_column :catalog_sets, :created_at, :timestamp
  end
end

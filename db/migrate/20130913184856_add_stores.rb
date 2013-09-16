class AddStores < ActiveRecord::Migration
  def change
    
    create_table :stores do |t|

      t.integer :user_id, :null => false
      t.string :name, :null => false
      t.text :landing_page
      t.text :about
      t.timestamps

    end

  end
end


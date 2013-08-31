class AddUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
      t.string :name
      t.string :email
      t.string :telephone
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :language_preference
      t.string :timezone
      t.string :username
      t.string :password
      t.boolean :agrees_to_tos
      t.text :about
 
      t.timestamps
    end
  end
end

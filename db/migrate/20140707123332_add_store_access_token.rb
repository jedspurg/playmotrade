class AddStoreAccessToken < ActiveRecord::Migration
  def change
    add_column :stores, :stripe_access_token, :string
  end
end

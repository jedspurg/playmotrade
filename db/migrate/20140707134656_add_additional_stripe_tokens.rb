class AddAdditionalStripeTokens < ActiveRecord::Migration
  def change
    add_column :stores, :stripe_refresh_token, :string
    add_column :stores, :stripe_user_id, :string
    add_column :stores, :stripe_publishable_key, :string
  end
end

class ChangeCountryOnUser < ActiveRecord::Migration
  def change
  	 reversible do |dir|
      change_table :users do |t|
        dir.up   { t.change :country, :integer }
        dir.down { t.change :country, :string }
      end
    end
  end
end
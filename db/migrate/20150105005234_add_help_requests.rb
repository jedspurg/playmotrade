class AddHelpRequests < ActiveRecord::Migration
  def change
    create_table :help_requests do |t|
      t.string :name
      t.references :user
      t.string :email
      t.string :comment
      t.timestamps
    end
  end
end

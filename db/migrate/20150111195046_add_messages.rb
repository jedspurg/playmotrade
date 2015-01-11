class AddMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :recipient_id, null: false
      t.references :user, null: false
      t.string :subject, null: false
      t.references :order
      t.string :body, null: false
      t.boolean :read, null: false, default: false
      t.date :read_at
      t.boolean :archive, null: false, default: false
      t.integer :parent_message_id
      t.string :disposition, null: false, default: 'system'
      t.timestamps
    end
  end
end

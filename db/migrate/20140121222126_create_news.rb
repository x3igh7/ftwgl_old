class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.integer :user_id, :null => false
      t.string :headline
      t.string :description
      t.text :content
      t.integer :newsable_id
      t.string :newsable_type
      t.timestamps
    end
  end
end

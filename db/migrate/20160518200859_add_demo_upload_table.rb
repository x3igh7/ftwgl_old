class AddDemoUploadTable < ActiveRecord::Migration
  def change
    create_table :match_demos do |t|
      t.integer :match_id, null: false
      t.integer :user_id, null: false
      t.string :demo, null: false
    end

    add_index :match_demos, [:match_id, :demo]
  end
end

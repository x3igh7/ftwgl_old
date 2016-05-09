class AddScreenshotsToMatch < ActiveRecord::Migration
  def change
    create_table :match_screenshots do |t|
      t.integer :match_id, null: false
      t.integer :user_id, null: false
      t.string :image, null: false
    end

    add_index :match_screenshots, [:match_id, :image]
  end
end

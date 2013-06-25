class AddTeamsTable < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :tag, null: false
    end
  end
end

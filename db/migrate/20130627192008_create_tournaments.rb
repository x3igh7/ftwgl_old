class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name, :null => false
      t.string :description
      t.text :rules

      t.timestamps
    end
  end
end

class TournamentAdmin < ActiveRecord::Migration
  def change
    create_table :tournament_admins do |t|
      t.integer :tournament_id, null: false, default: 0
      t.integer :user_id, null: false, default: 0

      t.timestamps
    end

    add_index :tournament_admins, [:tournament_id, :user_id], :unique => true
  end
end

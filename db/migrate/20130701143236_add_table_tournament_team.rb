class AddTableTournamentTeam < ActiveRecord::Migration
    def change
      create_table :tournament_teams do |t|
        t.integer :team_id, null: false
        t.integer :tournament_id, null: false
        t.integer :wins, :null => false, :default => 0
        t.integer :losses, :null => false, :default => 0
        t.integer :total_points, :null => false, :default => 0
        t.float   :total_diff, :null => false, :default => 0
        t.integer :rank
      
        t.timestamps
      end
    end
end

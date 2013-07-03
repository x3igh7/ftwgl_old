class RemoveTournamentMatchesTable < ActiveRecord::Migration
  def up
    drop_table :tournament_matches
  end

  def down
    create_table :tournament_matches do |t|
      t.integer :match_id, :null => false
      t.integer :tournament_team_id, :null => false
      t.integer :points
      t.integer :differential

      t.timestamps
    end
  end
end

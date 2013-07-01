class AddIndexesToTournamentTeams < ActiveRecord::Migration
  def change
    add_index :tournament_teams, [:team_id, :tournament_id], unique: true
    add_index :tournament_teams, :team_id
    add_index :tournament_teams, :tournament_id
  end
end

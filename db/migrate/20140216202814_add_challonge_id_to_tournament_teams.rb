class AddChallongeIdToTournamentTeams < ActiveRecord::Migration
  def change
    add_column :tournament_teams, :challonge_id, :integer, :default => 0
  end
end

class AddIsInactiveToTournamentTeam < ActiveRecord::Migration
  def change
    add_column :tournament_teams, :is_inactive, :boolean, null: false, default: false
  end
end

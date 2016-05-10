class UpdateMatchesTable < ActiveRecord::Migration
  def change
    add_column :matches, :map_name, :string

    add_column :matches, :home_team_round_one, :integer, null: false, default: 0
    add_column :matches, :home_team_round_two, :integer, null: false, default: 0
    add_column :matches, :home_team_round_three, :integer

    add_column :matches, :away_team_round_one, :integer, null: false, default: 0
    add_column :matches, :away_team_round_two, :integer, null: false, default: 0
    add_column :matches, :away_team_round_three, :integer

    add_column :matches, :home_team_differential, :float, null: false, default: 0
    add_column :matches, :away_team_differential, :float, null: false, default: 0

    add_column :matches, :reported_by, :integer
    add_column :matches, :disputed_by, :integer

    add_column :matches, :is_draw, :boolean, default: false

    rename_column :matches, :away_score, :away_points
    rename_column :matches, :home_score, :home_points

    remove_column :tournament_teams, :wins
    remove_column :tournament_teams, :losses
    remove_column :tournament_teams, :total_points
    remove_column :tournament_teams, :total_diff
    remove_column :tournament_teams, :rank

    add_column :tournaments, :can_join, :boolean, null: false, default: true
  end
end

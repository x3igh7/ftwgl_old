class UpdateMatchesTable < ActiveRecord::Migration
  def change
    add_column :matches, :map_name, :string

    add_column :matches, :home_team_round_one, :integer, null: false, default: 0
    add_column :matches, :home_team_round_two, :integer, null: false, default: 0
    add_column :matches, :home_team_round_three, :integer

    add_column :matches, :away_team_round_one, :integer, null: false, default: 0
    add_column :matches, :away_team_round_two, :integer, null: false, default: 0
    add_column :matches, :away_team_round_three, :integer

    add_column :matches, :home_team_differential, :float
    add_column :matches, :away_team_differential, :float

    add_column :matches, :reported_by, :integer
    add_column :matches, :disputed_by, :integer

    add_column :matches, :is_draw, :boolean, default: false

    rename_column :matches, :away_score, :away_points
    rename_column :matches, :home_score, :home_points

    drop_column :tournament_teams, :wins, :string
    drop_column :tournament_teams, :losses, :string
    drop_column :tournament_teams, :total_points, :integer
    drop_column :tournament_teams, :total_diff, :float
    drop_column :tournament_teams, :rank, :integer
  end
end

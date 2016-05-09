class UpdateMatchesTable < ActiveRecord::Migration
  def change
    add_column :matches, :map_name, :string

    add_column :matches, :home_team_round_one, :integer
    add_column :matches, :home_team_round_two, :integer
    add_column :matches, :home_team_round_three, :integer

    add_column :matches, :away_team_round_one, :integer
    add_column :matches, :away_team_round_two, :integer
    add_column :matches, :away_team_round_three, :integer

    add_column :matches, :reported_by, :integer
    add_column :matches, :disputed_by, :integer

    rename_column :matches, :away_score, :away_points
    rename_column :matches, :home_score, :home_points
  end
end

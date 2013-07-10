class AddIndexesToMatches < ActiveRecord::Migration
  def change
    add_index :matches, :tournament_id
    add_index :matches, :home_team_id
    add_index :matches, :away_team_id
  end
end

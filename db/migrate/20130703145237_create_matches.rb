class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :home_team_id, :null => false
      t.integer :away_team_id, :null => false
      t.integer :week_num, :null => false
      t.datetime :match_date, :null => false
      t.integer :home_score
      t.integer :away_score
      t.integer :winner_id
      t.timestamps
    end
  end
end

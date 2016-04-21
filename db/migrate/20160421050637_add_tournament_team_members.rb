class AddTournamentTeamMembers < ActiveRecord::Migration
  def change
  	create_table :tournament_team_membership do |t|
  		t.integer :tournament_id, null: false
  		t.integer :tournament_team_id, null: false
  		t.integer :user_id, null: false
  		t.string :authorization_id

  		t.timestamps
  	end

  	add_index :tournament_team_membership, [:tournament_id, :user_id], unique: true
  	add_index :tournament_team_membership, [:tournament_team_id]
  end
end

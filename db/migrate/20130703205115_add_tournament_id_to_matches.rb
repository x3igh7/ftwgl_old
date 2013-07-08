class AddTournamentIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :tournament_id, :integer, null: false
  end
end

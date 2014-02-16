class AddChallongeIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :challonge_id, :integer, :default => 0
  end
end

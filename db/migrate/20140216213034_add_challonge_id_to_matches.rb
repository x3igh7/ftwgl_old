class AddChallongeIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :challonge_id, :integer, :default => 0
    add_column :matches, :challonge_updated, :boolean, :default => false
  end
end

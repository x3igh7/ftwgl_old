class SetDefaultForScoresInMatches < ActiveRecord::Migration
	def change
		change_column :matches, :home_score, :integer, { :default => 0 }
		change_column :matches, :away_score, :integer, { :default => 0 }
	end
end

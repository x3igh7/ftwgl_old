class AddColumnCategoryToTournament < ActiveRecord::Migration
  def change
  	add_column :tournaments, :category, :string, :default => "none", :null => false
  end
end

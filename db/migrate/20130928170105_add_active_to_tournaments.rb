class AddActiveToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :active, :boolean, :default => true, :null => false
  end
end

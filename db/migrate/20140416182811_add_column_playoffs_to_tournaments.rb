class AddColumnPlayoffsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :playoffs, :boolean, :default => false
  end
end

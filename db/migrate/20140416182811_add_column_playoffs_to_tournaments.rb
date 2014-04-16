class AddColumnPlayoffsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournament, :playoffs, :boolean, :default => false
  end
end

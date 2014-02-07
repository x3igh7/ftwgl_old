class AddTypeBracketElimToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :type, :string, :default => "", :null => false
    add_column :tournaments, :bracket_type, :string
    add_column :tournaments, :elmination_type, :string
  end
end

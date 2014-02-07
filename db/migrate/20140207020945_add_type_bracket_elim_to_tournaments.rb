class AddTypeBracketElimToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :tournament_type, :string, :default => "", :null => false
    add_column :tournaments, :bracket_type, :string, :default => ""
    add_column :tournaments, :elimination_type, :string, :default => ""
    add_column :tournaments, :bracket_size, :integer, :default => 0
  end
end

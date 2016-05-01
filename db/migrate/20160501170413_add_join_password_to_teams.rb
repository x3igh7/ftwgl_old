class AddJoinPasswordToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :join_password_hash, :string, default: ''
    add_column :teams, :join_password_salt, :string, default: ''
  end
end

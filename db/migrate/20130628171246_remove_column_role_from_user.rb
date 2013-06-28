class RemoveColumnRoleFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :role
  end

  def down
    add_column :users, :role, :string, :null => false, :default => 'user'
  end
end

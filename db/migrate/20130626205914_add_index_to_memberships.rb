class AddIndexToMemberships < ActiveRecord::Migration
  def up
    add_index :memberships, [:user_id, :team_id], unique: true
    add_index :memberships, :user_id
    add_index :memberships, :team_id
  end

  def down
    remove_index :memberships, [:user_id, :team_id]
    remove_index :memberships, :user_id
    remove_index :memberships, :team_id
  end
end

class AddMembershipTable < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id, :null => false
      t.integer :team_id, :null => false
      t.string  :role, :null => false, :default => 'member'
      
      t.timestamps
    end
  end
end

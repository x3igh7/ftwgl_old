class AddActiveToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :active, :boolean, :null => false, :default => false
  end
end

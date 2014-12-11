class FixDefaultGravatarUrl < ActiveRecord::Migration
  def up
  	remove_column :users, :gravatar_email
  	remove_column :teams, :gravatar_email
  	add_column :teams, :gravatar_email, :string, :null=>false, :default => ""
    add_column :users, :gravatar_email, :string, :null=>false, :default => ""
  end

  def down
  	remove_column :users, :gravatar_email
  	remove_column :teams, :gravatar_email
  	add_column :teams, :gravatar_email, :string, :null=>false, :default => ""
  	add_column :users, :gravatar_email, :string, :default => ""
  end
end


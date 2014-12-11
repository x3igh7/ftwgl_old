class AddColumnGravatar < ActiveRecord::Migration
  def up
    add_column :users, :gravatar_email, :string
    remove_column :users, :avatar_url
  end

  def down
  	remove_column :users, :gravatar_email
  	add_column :users, :avatar_url, :string
  end
end


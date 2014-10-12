class AddGravatarUrlToTeams < ActiveRecord::Migration
  def change
  	add_column :teams, :gravatar_email, :string
  end
end

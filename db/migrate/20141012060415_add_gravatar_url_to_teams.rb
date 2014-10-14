class AddGravatarUrlToTeams < ActiveRecord::Migration
  def change
  	add_column :teams, :gravatar_email, :string
  	add_column :teams, :primary_contact, :string
  	add_column :teams, :secondary_contact, :string
  	add_column :teams, :website, :string
  	add_column :teams, :irc_channel, :string
  	add_column :teams, :voip, :string
  	add_column :teams, :youtube_channel, :string
    add_column :teams, :twitch_channel, :string
  	add_column :teams, :featured_video, :string
  	add_column :teams, :description, :text
  end
end

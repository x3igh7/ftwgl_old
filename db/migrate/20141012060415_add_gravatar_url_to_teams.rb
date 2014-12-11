class AddGravatarUrlToTeams < ActiveRecord::Migration
  def change
  	add_column :teams, :gravatar_email, :string, :default => ""
  	add_column :teams, :primary_contact, :string, :defualt => ""
  	add_column :teams, :secondary_contact, :string, :default => ""
  	add_column :teams, :website, :string, :default => ""
  	add_column :teams, :irc_channel, :string, :defualt => ""
  	add_column :teams, :voip, :string, :default => ""
  	add_column :teams, :youtube_channel, :string, :default => ""
    add_column :teams, :twitch_channel, :string, :default => ""
  	add_column :teams, :featured_video, :string, :default => ""
  	add_column :teams, :description, :text, :default => ""
  end
end

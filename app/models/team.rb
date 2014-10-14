class Team < ActiveRecord::Base
  validates_presence_of :name, :tag
  validates_length_of :name, :maximum => 50, :message => "Team name is too long"
  validates_length_of :tag, :maximum => 8, :message => "Maximum tag length is 8"

  attr_accessible :name, :tag, :gravatar_email, :primary_contact, :secondary_contact,
  :website, :irc_channel, :voip, :youtube_channel, :twitch_channel, :featured_video, :description

  has_many :memberships, :autosave => true, :dependent => :destroy
  has_many :users, through: :memberships
  has_many :tournament_teams
  has_many :tournaments, through: :tournament_teams

  def owners
    owners = memberships.where("role = 'owner'")
    owners.map { |owner| owner.user }
  end

  def actives
    actives = memberships.where("active = 'true'")
    actives.map { |active| active.user }
  end

  def members
    actives = memberships.where("active = 'true'")
    actives.map { |active| active.user }
  end

	def applications
		applications = memberships.where("active = 'false'")
		applications.map { |application| application.user }
	end

  def in_tournament?(tournament)
    if self.tournaments.where(id: tournament.id) != []
      return true
    else
      return false
    end
  end

  def save_with_owner(user)
    Team.transaction do
      save and Membership.create(:team => self, :user => user, :role => 'owner', :active => true)
    end
  end

  def total_wins
    total_wins = 0
    self.tournament_teams.each do |stats|
      total_wins += stats.wins
    end
    total_wins
  end

  def total_losses
    total_losses = 0
    self.tournament_teams.each do |stats|
      total_losses += stats.losses
    end
    total_losses
  end

  def winning_perc
    x = self.total_wins
    y = self.total_losses
    total = x + y
    if total == 0
      winning_perc = 0
    else
      winning_perc = (x.to_f / total) * 100
    end
    winning_perc.round(1)
  end

  def team_info
    @team_info = Hash.new

    if self.primary_contact
      @team_info["primary contact"] = self.primary_contact
    end

    if self.secondary_contact
      @team_info["secondary contact"] = self.secondary_contact
    end

    if self.website
      @team_info["website"] = self.website
    end

    if self.irc_channel
      @team_info["irc channel"] = self.irc_channel
    end

    if self.voip
      @team_info["voip info"] = self.voip
    end

    if self.youtube_channel
      @team_info["youtube channel"] = self.youtube_channel
    end

    if self.twitch_channel
      @team_info["twitch channel"] = self.twitch_channel
    end

    if self.description
      @team_info["description"] = self.description
    end

    @team_info
  end

end



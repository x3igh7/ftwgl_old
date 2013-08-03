class Team < ActiveRecord::Base
  validates_presence_of :name, :tag
  validates_length_of :name, :maximum => 50, :message => "Team name is too long"
  validates_length_of :tag, :maximum => 8, :message => "Maximum tag length is 8"

  attr_accessible :name, :tag

  has_many :memberships, :autosave => true
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

end



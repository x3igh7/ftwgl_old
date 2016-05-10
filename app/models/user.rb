require 'role_model'

class User < ActiveRecord::Base
  include RoleModel
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :lockable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :username, :password_confirmation, :remember_me

  attr_protected :roles_mask

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :title, :body
  validates_presence_of :email, :username
  has_many :memberships, dependent: :destroy
  has_many :teams, through: :memberships
  has_many :tournaments, through: :teams
  has_many :news, through: :tournaments
  has_many :matches, through: :tournament_teams
  has_many :comments, dependent: :destroy
  has_many :tournament_admins, dependent: :destroy
  has_many :tournament_teams, through: :teams
  has_many :tournament_team_memberships, dependent: :destroy
  has_many :match_screenshots

  roles_attribute :roles_mask
  roles :admin, :user, :banned

  before_save :default_roles

  def has_team_permissions?(team)
    @team = team

    if self.has_role?(:admin)
      return true
    end

    if self.is_tournament_admin?
      return true
    end

    self.memberships.each do |m|
      if m.team == @team
        if m.role == 'owner' || m.role == 'captain'
          return true
        end
      end
    end

    return false
  end

  def default_roles
    if self.roles_mask == nil
      self.roles = :user
    end
  end

  def update_and_remove_tournament_admins(user, id)
    User.transaction do
      self.update_attributes(user) and TournamentAdmin.where(:user_id => id).delete_all
    end
  end

  def total_wins
    @wins = 0

    self.teams.each do |team|
      @wins += team.total_wins
    end

    return @wins
  end

  def total_losses
    @losses = 0

    self.teams.each do |team|
      @losses += team.total_losses
    end

    return @losses
  end

  def total_matches
    @matches = 0

    @matches = self.total_wins + self.total_losses

    return @matches
  end

  def winning_perc
    @winning_perc = 100

    if self.total_matches != 0
      @winning_perc = (self.total_wins.to_f / self.total_matches.to_f)
    end

    return @winning_perc
  end

  def is_tournament_admin?
    self.tournament_admins.length > 0
  end

  def admin_tournaments
    self.tournament_admins.map { |t| t.tournament }
  end

  def admin_teams
    tournaments = self.admin_tournaments
    teams = []
    tournaments.each { |t| teams << t.teams }
    return teams.flatten
  end

  def admin_news
    tournament = self.admin_tournaments
    news = []
    news = tournaments.each { |t| news << t.news }
    return news.flatten
  end

  def is_team_owner?(team)
    team.owners.include?(self)
  end

  def is_team_captain?(team)
    team.captains.include?(self)
  end

  def is_team_member?(team)
    team.members.include?(self)
  end

  def has_applied?(team)
    team.applications.include?(self)
  end

  def banned?
    self.has_role?(:banned)
  end
end

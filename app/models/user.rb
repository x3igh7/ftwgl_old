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
  has_many :memberships
  has_many :teams, through: :memberships
  has_many :tournaments, through: :teams
  has_many :news, through: :tournaments
  has_many :matches, through: :tournaments
  has_many :comments

  roles_attribute :roles_mask
  roles :admin, :user, :banned, :tournament_admin

  before_save :default_roles

  def default_roles
    if self.roles_mask == nil
      self.roles = :user
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

  def winning_perc
    @winning_perc = 100

    if self.total_losses != 0
      @winning_perc = (self.total_wins / self.total_losses)
    end

    return @winning_perc
  end

  def is_team_owner?(team)
    team.owners.include?(self)
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

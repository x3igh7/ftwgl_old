require 'role_model'

class User < ActiveRecord::Base
  include RoleModel
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :username, :password_confirmation, :remember_me

  attr_protected :roles_mask

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :title, :body
  validates_presence_of :email, :username
  has_many :memberships
  has_many :teams, through: :memberships
  has_many :tournaments, through: :teams

  roles_attribute :roles_mask
  roles :admin, :user, :banned

  before_save :default_roles
	
  def default_roles
    if self.roles_mask == nil
      self.roles = :user
    end
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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :username, :role, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  validates_inclusion_of :role, :in => ['admin', 'user']
  validates_presence_of :email, :password, :username
  has_many :memberships
  has_many :teams, through: :memberships

  ROLES = %w[admin user]
  
  def role_symbols
    [role.to_sym]
  end
  
end

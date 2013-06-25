class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :username, :role, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  validates_presence_of :email, :password, :username
  has_many :memberships
  has_many :teams, through: :memberships
end

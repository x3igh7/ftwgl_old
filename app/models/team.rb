class Team < ActiveRecord::Base
  validates_presence_of :name, :tag
  validates_length_of :name, :maximum => 50, :message => "Team name is too long"
  validates_length_of :tag, :maximum => 8, :message => "Maximum tag length is 8"

  attr_accessible :name, :tag

  has_many :memberships, :autosave => true
  has_many :users, through: :memberships

  def owners
    owners = memberships.where("role = 'owner'")
    owners.map { |owner| owner.user }
  end

  def actives
    actives = memberships.where("active = 'true'")
    actives.map { |active| active.user }
  end

  def active?(user,team)
    user.memberships.where(:team_id => team.id).last.active
  end

  def members
    members = memberships.where("role = 'member'")
    members.map { |member| member.user }
  end

  def save_with_owner(user)
    Team.transaction do
      save and Membership.create(:team => self, :user => user, :role => 'owner', :active => true)
    end
  end

end

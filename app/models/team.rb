class Team < ActiveRecord::Base
  validates_presence_of :name, :tag

  attr_accessible :name, :tag

  has_many :memberships, :autosave => true

  def owners
    owners = memberships.where("role = 'owner'")
    owners.map { |owner| owner.user }
  end

  def save_with_owner(user)
    Team.transaction do
      save and Membership.create(:team => self, :user => user, :role => 'owner')
    end
  end

end

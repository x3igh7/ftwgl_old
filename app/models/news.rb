class News < ActiveRecord::Base
  attr_accessible :headline, :content, :newsable_id, :user, :user_id

  belongs_to :newsable, :polymorphic => true
  has_many :comments, :as => :commentable, :dependent => :destroy
  belongs_to :user
end

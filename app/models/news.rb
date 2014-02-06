class News < ActiveRecord::Base
  attr_accessible :headline, :description, :content, :newsable_id, :user

  belongs_to :newsable, :polymorphic => true
  has_many :comments, :as => :commentable, :dependent => :destroy
  belongs_to :user
end

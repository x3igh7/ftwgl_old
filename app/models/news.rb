class News < ActiveRecord::Base
  attr_accessible :headline, :description, :content, :newsable_id

  belongs_to :newsable, :polymorphic => true
end

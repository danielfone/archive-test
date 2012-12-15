class BoolWidget < ActiveRecord::Base
  attr_accessible :archived, :name

  scope :current,  where(archived: false)
  scope :archived, where(archived: true)
end

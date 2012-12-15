class DateWidget < ActiveRecord::Base
  attr_accessible :archived_at, :name

  scope :current,  where('archived_at is null')
  scope :archived, where('archived_at is not null')
end

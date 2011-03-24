# One partition of the participants of a course
class Group < ActiveRecord::Base
  has_many :event_group_associations, :dependent => :destroy
  has_many :events, :through => :event_group_associations
end
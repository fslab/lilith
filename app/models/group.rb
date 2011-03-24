# One partition of the participants of a course
class Group < ActiveRecord::Base
  has_many :event_associations,
           :class_name => 'EventGroupAssociation',
           :dependent => :destroy
  has_many :events, :through => :event_associations
end
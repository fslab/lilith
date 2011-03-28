# A person who organizes an event
class Tutor < ActiveRecord::Base
  has_many :event_associations,
           :class_name => 'EventTutorAssociation',
           :dependent => :destroy
  has_many :events, :through => :event_associations
end


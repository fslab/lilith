class Event < ActiveRecord::Base
  has_many :event_tutor_associations, :dependent => :destroy
  has_many :tutors, :through => :event_tutor_associations
  has_many :event_group_associations, :dependent => :destroy
  has_many :groups, :through => :event_group_associations
end
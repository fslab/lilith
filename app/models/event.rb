# Possibly recurring event in a course
class Event < ActiveRecord::Base
  has_many :tutor_associations,
           :class_name => 'EventTutorAssociation',
           :dependent => :destroy
  has_many :tutors, :through => :tutor_associations

  has_many :group_associations,
           :class_name => 'EventGroupAssociation',
           :dependent => :destroy
  has_many :groups, :through => :event_group_associations

  has_many :category_associations,
           :class_name => 'CategoryEventAssociation',
           :dependent => :destroy
  has_many :categories, :through => :category_associations
end
class Schedule < ActiveRecord::Base
  include Lilith::UUIDHelper

  belongs_to :user
  belongs_to :schedule_state

  has_many :course_associations, :class_name => 'Schedule::CourseAssociation'
  has_many :courses, :through => :course_associations

  validates :name, :uniqueness => {:scope => :user_id}
end
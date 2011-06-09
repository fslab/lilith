class Schedule::CourseAssociation < ActiveRecord::Base
  include Lilith::UUIDHelper

  belongs_to :schedule
  belongs_to :course

  validates :course_id, :uniqueness => {:scope => :schedule_id}
end
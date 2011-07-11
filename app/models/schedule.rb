class Schedule < ActiveRecord::Base
  include Lilith::UUIDHelper

  belongs_to :user
  belongs_to :fixed_schedule_state, :class_name => 'ScheduleState'

  has_many :course_associations, :class_name => 'Schedule::CourseAssociation'
  has_many :courses, :through => :course_associations
  has_many :group_associations, :class_name => 'Schedule::GroupAssociation'
  has_many :groups, :through => :group_associations

  validates :name, :uniqueness => {:scope => :user_id, :allow_nil => true},
                   :format => /[a-z_-]+/, :allow_nil => true

  attr_accessible :name, :description, :public, :fixed_schedule_state_id

  default_scope order('user_id DESC, name ASC, updated_at DESC')

  # Only permanent schedules
  def self.permanent
    where('name IS NOT NULL')
  end

  # Only temporary schedules
  def self.temporary
    where(:name => nil)
  end

  # Only public schedules
  def self.public
    where(:public => true)
  end

  # Only private schedules
  def self.private
    where(:public => false)
  end

  # If a schedule state is set, it is returned,
  # if not, the latest schedule state is returned
  def schedule_state
    fixed_schedule_state || ScheduleState.latest
  end

  # Tells if the schedule is temporary, which is the case if it has no name
  def temporary?
    @name.nil?
  end

  # Tells if the schedule is permanent, which is the case if it has a name
  def permanent?
    !temporary?
  end

  # Accumulates a set of events from all associated event sources
  def events
    events = Set.new

    (courses + groups).each do |element|
      events += element.events.exclusive(schedule_state)
    end

    events
  end

  # Generates an iCalendar object
  def to_ical
    calendar = RiCal::Component::Calendar.new
    calendar.prodid = "-//fslab.de/NONSGML Lilith #{Lilith::VERSION}/EN"

    events.each do |event|
      calendar.add_subcomponent(event.to_ical)
    end

    calendar
  end
end
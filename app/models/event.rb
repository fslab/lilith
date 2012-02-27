# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2011

This file is part of Lilith.

Lilith is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Lilith is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Lilith.  If not, see <http://www.gnu.org/licenses/>.
=end

# Possibly recurring event in a course
class Event < ActiveRecord::Base
  include Lilith::UUIDHelper

  belongs_to :course
  belongs_to :schedule_state

  has_many :lecturer_associations,
           :class_name => 'EventLecturerAssociation',
           :dependent => :destroy
  has_many :lecturers, :through => :lecturer_associations

  has_many :group_associations,
           :class_name => 'EventGroupAssociation',
           :dependent => :destroy
  has_many :groups, :through => :group_associations

  has_many :category_associations,
           :class_name => 'CategoryEventAssociation',
           :dependent => :destroy
  has_many :categories, :through => :category_associations

  has_many :week_associations,
           :class_name => 'EventWeekAssociation',
           :dependent => :destroy
  has_many :weeks, :through => :week_associations

  # Returns all occurrences of this event as Aef::Weekling::WeekDay objects
  def occurrences
    occurrence_weeks = weeks.map(&:to_week)

    first_week_day = Aef::Weekling::WeekDay.new(first_start)

    holidays  = Lilith::HolidayList.for(weeks.first.year)
    holidays += Lilith::HolidayList.for(weeks.last.year)

    occurrence_week_days = occurrence_weeks.map!{|week| week.day(first_week_day.index) }
    occurrence_week_days.reject{|week_day| holidays.any?{|holiday| holiday == week_day } }
  end

  # Returns all exceptions of this event as Aef::Weekling::WeekDay objects
  def exceptions
    first_week_day = Aef::Weekling::WeekDay.new(first_start)

    course.study_unit.semester.weeks.map{|week| week.day(first_week_day.index) } - occurrences
  end

  # Generates an iCalendar event
  def to_ical
    ical_event = RiCal::Component::Event.new

    ical_event.dtstart = first_start
    ical_event.dtend   = first_end
    ical_event.summary = "#{course.name} (#{categories.map{|category| category.name || category.eva_id}.join(', ')})"
    ical_event.location   = "Hochschule Bonn-Rhein-Sieg, #{I18n.t('schedules.room')}: #{room}"
    ical_event.categories = categories.map{|category| category.name || category.eva_id}

    description = ""
    description += "#{I18n.t('schedules.lecturers')}: #{lecturers.map(&:name).join(', ')}\n" unless lecturers.empty?
    description += "#{I18n.t('schedules.groups')}: #{groups.map(&:name).join(', ')}\n" unless groups.empty?

    ical_event.description = description

    # If recurrence is needed, make event recurring each week and define exceptions
    #
    # This is needed because Evolution 2.30.3 still has problems interpreting rdate recurrence
    # 
    # Although iCalendar chapter 4.3.10 "Recurrence Rule" states "The UNTIL rule part defines a date-time value which
    # bounds the recurrence rule in an inclusive manner.", some programs interpret this in an exclusive manner (Sunbird,
    # Terminplaner.Net). Therefore the day after the real until date is chosen, which should not cause problems in a
    # weekly recurrence.
    if weeks.length > 1
      ical_event.exdates = exceptions.map(&:to_date)
      ical_event.rrules = [{:freq => 'weekly', :until => self.until + 1}]
    end
    
    ical_event
  end
end

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
  belongs_to :schedule

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

  # Returns all occurences of this event as Date objects
  def occurences
    occurence_weeks = weeks.map(&:to_week)

    first_week_day = Aef::WeekDay.new(first_start)
    
    occurence_weeks.map!{|week| week.day(first_week_day.index) }
  end

  # Returns all exceptions of this event as Date objects
  def exceptions
    exception_weeks = course.study_unit.semester.weeks - weeks.map(&:to_week)

    first_week_day = Aef::WeekDay.new(first_start)

    exception_weeks.map!{|week| week.day(first_week_day.index) }
  end

  # Generates an iCalendar event
  #
  # TODO: Translate with I18n
  def to_ical
    ical_event = RiCal::Component::Event.new

    ical_event.dtstart = first_start
    ical_event.dtend   = first_end
    ical_event.summary = "#{course.name} (#{categories.map{|category| category.name || category.eva_id}.join(', ')})"
    ical_event.location   = "Hochschule Bonn-Rhein-Sieg, Raum: #{room}"
    ical_event.categories = categories.map{|category| category.name || category.eva_id}

    description = ""
    description += "Dozenten: #{lecturers.map(&:name).join(', ')}\n" unless lecturers.empty?
    description += "Gruppen: #{groups.map(&:name).join(', ')}\n" unless groups.empty?

    ical_event.description = description

    # If recurrence is needed, make event recurring each week and define exceptions
    # This is needed because Evolution 2.30.3 still has problems interpreting rdate recurrence
    if weeks.length > 1
      ical_event.exdates = exceptions.map(&:to_date)
      ical_event.rrules = [{:freq => 'weekly', :until => self.until}]
    end
    
    ical_event
  end
end
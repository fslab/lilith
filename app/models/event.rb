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
  belongs_to :course
  belongs_to :plan

  has_many :tutor_associations,
           :class_name => 'EventTutorAssociation',
           :dependent => :destroy
  has_many :tutors, :through => :tutor_associations

  has_many :group_associations,
           :class_name => 'EventGroupAssociation',
           :dependent => :destroy
  has_many :groups, :through => :group_associations

  has_many :category_associations,
           :class_name => 'CategoryEventAssociation',
           :dependent => :destroy
  has_many :categories, :through => :category_associations

  def to_ical
    ical_event = Icalendar::Event.new

    ical_event.dtstart = first_start.to_datetime
    ical_event.dtend   = first_end.to_datetime
    ical_event.summary = "#{course.name} (#{categories.map{|category| category.name || category.eva_id}.join(', ')})"
    ical_event.location   = "Hochschule Bonn-Rhein-Sieg, Raum: #{room}"
    ical_event.categories = categories.map{|category| category.name || category.eva_id}

    description = ""
    description += "Veranstalter: #{tutors.map{|tutor| tutor.name || tutor.eva_id}.join(', ')}\n" unless tutors.empty?
    description += "Gruppen: #{groups.map(&:name).join(', ')}\n" unless groups.empty?

    ical_event.description = description

    /((?:u|g)KW) (.*)/ =~ recurrence

    case $1
    when 'uKW', 'gKW'
      ical_event.recurrence_rules ["FREQ=WEEKLY;INTERVAL=2;UNTIL=#{self.until.strftime('%Y%m%d')}"]
    else
      ical_event.recurrence_rules ["FREQ=WEEKLY;UNTIL=#{self.until.strftime('%Y%m%d')}"]
    end

    ical_event
  end
end
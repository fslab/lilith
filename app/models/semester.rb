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

# One of two periods in a year in which study units occur
class Semester < ActiveRecord::Base
  include Lilith::UUIDHelper
  
  has_many :study_units, :dependent => :destroy
  has_many :schedules, :dependent => :destroy

  # Finds a Semester by either be it's UUID or the token
  def self.find(*args)
    UUIDTools::UUID.parse(args.first) if args.length == 1
    super(*args)
  rescue ArgumentError
    /(\d+)([ws])/ =~ args.first

    case $2
    when 'w'
      season = :winter
    when 's'
      season = :summer
    else
      raise ArgumentError, 'Invalid semester season'
    end

    @semester = find_by_start_year_and_season($1.to_i, season)
  end

  # Finds the latest Semester object
  def self.latest
    Semester.order('start_year DESC, season DESC').first
  end

  # Generates a name for the semester that is intended to be human readable
  def name
    case season.to_sym
    when :winter
      "WS #{start_year}/#{start_year + 1}"
    when :summer
      "SS #{start_year}"
    end
  end

  # Generates a token consisting of the year and the lower case beginning
  # letter of the season
  #
  # Examples: 2011s, 2012w, 2012s
  def token
    case season.to_sym
    when :winter
      "#{start_year}w"
    when :summer
      "#{start_year}s"
    end
  end

  # Sets start week either by String or Lilith::Week
  def start_week=(start_week)
    write_attribute(:start_week, start_week.to_s)
  end

  # Returns the start week as Lilith::Week
  def start_week
    Lilith::Week.parse(read_attribute(:start_week))
  end

  # Sets end week either by String or Lilith::Week
  def end_week=(end_week)
    write_attribute(:end_week, end_week.to_s)
  end

  # Returns the end week as Lilith::Week
  def end_week
    Lilith::Week.parse(read_attribute(:end_week))
  end

  # Returns the range between start week and end week
  def weeks
    start_week .. end_week
  end
end

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

require 'aef/week'

module Aef
  
end

# Immutable object representing a calendar week (according to ISO8601)
class Aef::Week
  include Comparable

  PARSE_PATTERN = /(0|-?\d+)-W(0[1-9]|(?:1|2|3|4)\d|5(?:0|1|2|3))/

  # Calculates the amount of weeks in a given year
  def self.weeks_in_year(year)
    date = Date.new(year, 12, 31)

    date = date - 7 if date.cweek == 1

    date.cweek
  end

  # Initializes the current week
  def self.today
    today = Date.today

    new(today.year, today.cweek)
  end

  singleton_class.class_eval do
    alias now today
  end

  # Parses a the first week out of a string
  #
  # Looks for patterns like this:
  #
  #  2011-W03
  def self.parse(string)
    if sub_matches = PARSE_PATTERN.match(string.to_s)
      original, year, index = *sub_matches
      new(year.to_i, index.to_i)
    else
      raise ArgumentError, 'No week found for parsing'
    end
  end

  singleton_class.class_eval do
    alias [] new
  end

  attr_reader :year, :index

  # Initializes a week object
  #
  # It either expects a year and a week index which support to_i
  # or a single argument which supports to_date
  def initialize(*arguments)
    case arguments.count
    when 1
      object = arguments.first
      if [:year, :index].all?{|method| object.respond_to?(method) }
        @year  = object.year.to_i
        @index = object.index.to_i
      elsif object.respond_to?(:to_date)
        date = object.to_date
        @year  = date.year
        @index = date.cweek
      else
        raise ArgumentError, 'A single argument must either respond to year and index or to to_date'
      end
    when 2
      year, index = *arguments
      @year  = year.to_i
      @index = index.to_i
    else
      raise ArgumentError, "wrong number of arguments (#{arguments.count} for 1..2)"
    end

    if not (1..52).include?(@index)
      if @index == 53
        if self.class.weeks_in_year(year) == 52
          raise ArgumentError, "Index #{@index} is invalid. Year #{year} has only 52 weeks"
        end
      else
        raise ArgumentError, "Index #{@index} is invalid. Index can never be lower than 1 or higher than 53"
      end
    end

  end

  # Represents a week as String in ISO8601 format (without day)
  #
  # For example:
  #
  #  2012-W13
  def to_s
    "#{'%04i' % year}-W#{'%02i' % index}"
  end

  def to_week
    self
  end

  # Equal if same week in the same year
  def ==(other)
    year == other.year and index == other.index
  end

  # Equal if same week in the same year, of same class
  def eql?(other)
    other.is_a?(self.class) and self == other
  end

  # Identity hash for hash tables usage
  def hash
    [year, index].hash
  end

  # Compares if the other object is
  def <=>(other)
    year_comparison = year <=> other.year

    return index <=> other.index if year_comparison == 0
    return year_comparison
  end

  # Finds the following week
  def next
    if index < 52
      self.class.new(year, index + 1)
    elsif self.class.weeks_in_year(year) == 53 and index == 52
      self.class.new(year, index + 1)
    else
      self.class.new(year + 1, 1)
    end
  end

  alias succ next

  # Find the previous week
  def previous
    if index > 1
      self.class.new(year, index - 1)
    elsif self.class.weeks_in_year(year - 1) == 53
      self.class.new(year - 1, 53)
    else
      self.class.new(year - 1, 52)
    end
  end

  alias pred previous

  # Returns a range of weeks beginning with self and ending with the first
  # following week with the given index
  def until_index(end_index)
    if end_index <= index
      self .. self.class.new(year + 1, end_index)
    else
      self .. self.class.new(year, end_index)
    end
  end

  # States if the week's index is odd
  def odd?
    index.odd?
  end

  # States if the week's index is even
  def even?
    index.even?
  end

  # Returns the weeks monday
  def monday
    Aef::WeekDay.new(self, :monday)
  end

  # Returns the weeks tuesday
  def tuesday
    Aef::WeekDay.new(self, :tuesday)
  end

  # Returns the weeks wednesday
  def wednesday
    Aef::WeekDay.new(self, :wednesday)
  end

  # Returns the weeks thursday
  def thursday
    Aef::WeekDay.new(self, :thursday)
  end

  # Returns the weeks friday
  def friday
    Aef::WeekDay.new(self, :friday)
  end

  # Returns the weeks saturday
  def saturday
    Aef::WeekDay.new(self, :saturday)
  end

  # Returns the weeks sunday
  def sunday
    Aef::WeekDay.new(self, :sunday)
  end

  # Returns the weeks saturday and sunday in an Array
  def weekend
    [saturday, sunday]
  end

  # Returns a range from monday to sunday
  def days
    monday..sunday
  end

  # Returns a WeekDay by given index or symbol
  def day(index_or_symbol)
    Aef::WeekDay.new(self, index_or_symbol)
  end
end
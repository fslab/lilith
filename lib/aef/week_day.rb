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

# Immutable object representing a calendar week day (according to ISO8601)
class Aef::WeekDay
  include Comparable

  SYMBOL_TO_INDEX_TABLE = {
    :monday    => 1,
    :tuesday   => 2,
    :wednesday => 3,
    :thursday  => 4,
    :friday    => 5,
    :saturday  => 6,
    :sunday    => 7
  }.freeze

  # Initializes the current week day
  def self.today
    today = Date.today
    
    new(today, today.wday)
  end

  singleton_class.class_eval do
    alias now today
  end

  # Parses a the first week day out of a string
  #
  # Looks for patterns like this:
  #
  #  2011-W03-5
  def self.parse(string)
    if sub_matches = /#{Aef::Week::PARSE_PATTERN}-([1-7])/.match(string.to_s)
      original, year, week_index, day_index = *sub_matches
      new(year.to_i, week_index.to_i, day_index.to_i)
    else
      raise ArgumentError, 'No week day found for parsing'
    end
  end

  singleton_class.class_eval do
    alias [] new
  end

  attr_reader :week, :index

  # Initializes a week day object
  def initialize(*arguments)
    case arguments.count
    when 1
      object = arguments.first
      if [:week, :index].all?{|method| object.respond_to?(method) }
        @week  = Aef::Week.new(object.week)
        @index = object.index.to_i
      elsif object.respond_to?(:to_date)
        date = object.to_date
        @week  = Aef::Week.new(date)
        @index = date.wday
      else
        raise ArgumentError, 'A single argument must either respond to week and index or to to_date'
      end
    when 2
      week, day = *arguments
      @week  = Aef::Week.new(week)
      if day.respond_to?(:to_i)
        @index = day.to_i
      else
        raise ArgumentError, 'Invalid day symbol' unless @index = SYMBOL_TO_INDEX_TABLE[day.to_sym]
      end
    when 3
      year, week_index, day = *arguments
      @week  = Aef::Week.new(year, week_index)
      if day.respond_to?(:to_i)
        @index = day.to_i
      else
        raise ArgumentError, 'Invalid day symbol' unless @index = SYMBOL_TO_INDEX_TABLE[day.to_sym]
      end
    else
      raise ArgumentError, "wrong number of arguments (#{arguments.count} for 1..3)"
    end

    raise ArgumentError, 'Index must be in 1..7' unless (1..7).include?(index)
  end

  # Represents a week as String in ISO8601 format
  #
  # For example:
  #
  #  2012-W13-4
  def to_s
    "#{week}-#{index}"
  end

  def to_sym
    SYMBOL_TO_INDEX_TABLE.invert[index]
  end

  # Returns the Date of the week day
  def to_date
    date = Date.new(week.year, 1, 1)

    days_to_add = 7 * week.index
    days_to_add -= 7 if date.cweek == 1
    days_to_add -= date.wday
    days_to_add += index

    date + days_to_add
  end

  # Returns itself
  def to_week_day
    self
  end

  # Equal if same day in the same week
  def ==(other)
    week == other.week and index == other.index
  end

  # Equal if same day in the same week, of same class
  def eql?(other)
    other.is_a?(self.class) and self == other
  end

  # Identity hash for hash tables usage
  def hash
    [week, index].hash
  end

  # Compares if the other object is
  def <=>(other)
    week_comparison = week <=> other.week

    return index <=> other.index if week_comparison == 0
    return week_comparison
  end

  # Finds the following week day
  def next
    if index == 7
      self.class.new(week.next, 1)
    else
      self.class.new(week, index + 1)
    end
  end

  alias succ next

  # Find the previous week day
  def previous
    if index == 1
      self.class.new(week.previous, 7)
    else
      self.class.new(week, index - 1)
    end
  end

  alias pred previous

  # True if week day is monday
  def monday?
    to_sym == :monday
  end

  # True if week day is tuesday
  def tuesday?
    to_sym == :tuesday
  end

  # True if week day is wednesday
  def wednesday?
    to_sym == :wednesday
  end

  # True if week day is thursday
  def thursday?
    to_sym == :thursday
  end

  # True if week day is friday
  def friday?
    to_sym == :friday
  end

  # True if week day is saturday
  def saturday?
    to_sym == :saturday
  end

  # True if week day is sunday
  def sunday?
    to_sym == :sunday
  end

  # True if week day is saturday or sunday
  def weekend?
    saturday? or sunday?
  end
end
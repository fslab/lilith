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

module Aef
  
end

# Immutable object representing a calendar week
class Aef::Week
  include Comparable

  WEEK_PATTERN = /(0|-?\d+)-W(0[1-9]|(?:1|2|3|4)\d|5(?:0|1|2|3))/

  attr_reader :year, :index

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

  # Parses a the first week out a string
  #
  # Looks for patterns like this:
  #
  #  2011-W03
  def self.parse(string)
    if WEEK_PATTERN =~ string.to_s
      new($1.to_i, $2.to_i)
    else
      raise ArgumentError, 'No week found for parsing'
    end
  end

  singleton_class.class_eval do
    alias [] new
  end

  # Initializes a week object
  #
  # It either expects a year and a week index which support to_i
  # or a single argument which supports to_date
  def initialize(*args)
    if args.length == 2
      @year  = args[0].to_i
      @index = args[1].to_i
    else
      date = args[0].to_date
      @year  = date.year
      @index = date.cweek
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
end
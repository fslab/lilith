# Immutable object representing a calendar week
class Lilith::Week
  include Comparable

  WEEK_PATTERN = /(0|-?\d+)-W(0[1-9]|(?:1|2|3|4)\d|5(?:0|1|2|3))/

  attr_reader :year, :index

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
        if Date.parse("#{year}-12-31").cweek == 52
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
end
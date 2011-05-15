class Holidays
  class Holiday
    attr_reader :name
    def initialize(*arguments)
      case arguments.length
      when 2
        date, name = *arguments
        @date = Date.new(date.year, date.month, date.day)
      when 4
        year, month, day, name = *arguments
        @date = Date.new(year, month, day)
      else
        raise ArgumentError, 'invalid argument count'
      end
      @name = name.freeze
    end

    def ==(other)
      @date == other.to_date
    end

    def <=>(other)
      @date <=> other.to_date
    end
    def eql?(other)
      self == other and other.is_a?(self.class)
    end

    alias old_respond_to? respond_to?

    def respond_to?(name, include_private = false)
      old_respond_to?(name, include_private) or @date.respond_to?(name, include_private)
    end

    protected

    def method_missing(name, *arguments)
      @date.method(name).call(*arguments)
    end
  end

  include Enumerable

  def self.for(year)
    @holidays_by_year ||= {}
    @holidays_by_year[year.to_i] ||= new(year.to_i)
  end

  attr_reader :year, :holidays
  def initialize(year)
    @year = year.to_i
    @holidays = (fixed_holidays + variable_holidays).sort.freeze
  end

  def each(&block)
    holidays.each(&block)
  end

  def last
    holidays.last
  end

  def fixed_holidays
    [
      Holiday.new(@year, 1, 1, 'Neujahr'),
      Holiday.new(@year, 5, 1, 'Tag der Arbeit'),
      Holiday.new(@year, 10, 3, 'Tag der deutschen Einheit'),
      Holiday.new(@year, 11, 1, 'Allerheiligen'),
      Holiday.new(@year, 12, 25, '1. Weihnachtsfeiertag'),
      Holiday.new(@year, 12, 26, '2. Weihnachtsfeiertag')
    ]
  end

  def calculate_easter
    Date.easter(@year)
  end

  def variable_holidays
    easter = calculate_easter
    [
      Holiday.new(easter - 2,  'Karfreitag'),
      Holiday.new(easter,      'Ostersonntag'),
      Holiday.new(easter + 1,  'Ostermontag'),
      Holiday.new(easter + 39, 'Christi Himmelfahrt'),
      Holiday.new(easter + 50, 'Pfingstmontag'),
      Holiday.new(easter + 60, 'Fronleichnam')
    ]
  end

  def find(name = nil, &block)
    if name.is_a?(String)
      holidays.find{|holiday| holiday.name == name.to_s }
    else
      holidays.find(&block)
    end
  end
end
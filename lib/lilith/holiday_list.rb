require 'lilith/holiday'

class Lilith::HolidayList
  include Enumerable

  def self.for(year)
    @holidays_by_year ||= {}
    @holidays_by_year[year.to_i] ||= new(year.to_i)
  end

  def initialize(*arguments)
    if arguments.length == 1
      year = arguments.first
      @year = year.to_i
      @holidays = (fixed_holidays + variable_holidays).sort.freeze
    else
      @holiday_lists = arguments.to_a.sort.freeze
    end
  end

  def year
    if @holiday_lists
      @holiday_lists.map(&:year).uniq
    else
      @year
    end
  end

  def holidays
    if @holiday_lists
      holidays = []
      @holiday_lists.each do |holiday_list|
        holidays += holiday_list.holidays
      end
      holidays.uniq.freeze
    else
      @holidays
    end
  end


  def each(&block)
    holidays.each(&block)
  end
  
  def <=>(other)
    @year <=> other.year
  end

  def +(other)
    self.class.new(self, other)
  end

  def last
    holidays.last
  end

  def fixed_holidays
    [
      Lilith::Holiday.new(@year, 1, 1, 'Neujahr'),
      Lilith::Holiday.new(@year, 5, 1, 'Tag der Arbeit'),
      Lilith::Holiday.new(@year, 10, 3, 'Tag der deutschen Einheit'),
      Lilith::Holiday.new(@year, 11, 1, 'Allerheiligen'),
      Lilith::Holiday.new(@year, 12, 25, '1. Weihnachtsfeiertag'),
      Lilith::Holiday.new(@year, 12, 26, '2. Weihnachtsfeiertag')
    ]
  end

  def calculate_easter
    Date.easter(@year)
  end

  def variable_holidays
    easter = calculate_easter
    [
      Lilith::Holiday.new(easter - 2,  'Karfreitag'),
      Lilith::Holiday.new(easter,      'Ostersonntag'),
      Lilith::Holiday.new(easter + 1,  'Ostermontag'),
      Lilith::Holiday.new(easter + 39, 'Christi Himmelfahrt'),
      Lilith::Holiday.new(easter + 50, 'Pfingstmontag'),
      Lilith::Holiday.new(easter + 60, 'Fronleichnam')
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
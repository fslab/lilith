# One of two periods in a year in which study units occur
class Semester < ActiveRecord::Base
  has_many :study_units, :dependent => :destroy
  
  def name
    year = begin_year.year
  
    case season.to_sym
    when :winter
      "WS #{year}/#{year + 1}"
    when :summer
      "SS #{year}"
    end
  end
end

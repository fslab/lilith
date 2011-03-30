# One of two periods in a year in which study units occur
class Semester < ActiveRecord::Base
  has_many :study_units, :dependent => :destroy
  
  def name
    case season.to_sym
    when :winter
      "WS #{start_year}/#{start_year + 1}"
    when :summer
      "SS #{start_year}"
    end
  end
end

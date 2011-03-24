# One of two periods in a year in which study units occur
class Semester < ActiveRecord::Base
  has_many :study_units, :dependent => :destroy
end
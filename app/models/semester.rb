class Semester < ActiveRecord::Base
  has_many :study_units, :dependent => :destroy
end
# Collection of scheduled events of a study unit at a specific point in time
class Plan < ActiveRecord::Base
  belongs_to :study_unit
  has_many :courses, :dependent => :destroy
end
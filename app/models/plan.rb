class Plan < ActiveRecord::Base
  belongs_to :study_unit
  has_many :courses, :dependent => :destroy
end
# One of the scheduled partitions of a study program
class StudyUnit < ActiveRecord::Base
  belongs_to :semester
  has_many :plans, :dependent => :destroy
end
# One of the scheduled partitions of a study program
class StudyUnit < ActiveRecord::Base
  belongs_to :semester
  has_many :courses, :dependent => :destroy
  has_many :plans, :dependent => :destroy
  
  def name
    "#{program} #{position}"
  end
end

class StudyUnit < ActiveRecord::Base
  belongs_to :semester
  has_many :plans, :dependent => :destroy
end
# One of the topics of a study unit
class Course < ActiveRecord::Base
  belongs_to :study_unit
  has_many :events, :dependent => :destroy
  has_many :groups, :dependent => :destroy
end
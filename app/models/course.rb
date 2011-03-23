class Course < ActiveRecord::Base
  belongs_to :plan
  has_many :events, :dependent => :destroy
  has_many :groups, :dependent => :destroy
end
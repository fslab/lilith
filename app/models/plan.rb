class Plan < ActiveRecord::Base
  belongs_to :semester
  has_many :courses, :dependent => :destroy
end
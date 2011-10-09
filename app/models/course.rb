puts "Fnord2000"

class Course < ActiveRecord::Base
  has_many :comments, dependent: :destroy
end

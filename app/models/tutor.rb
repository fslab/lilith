class Tutor < ActiveRecord::Base
  has_many :event_tutor_associations, :dependent => :destroy
  has_many :events, :through => :event_tutor_associations
end
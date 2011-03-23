class EventTutorAssociation < ActiveRecord::Base
  belongs_to :event
  belongs_to :tutor
end
class EventWeekAssociation < ActiveRecord::Base
  include Lilith::UUIDHelper

  belongs_to :event
  belongs_to :week
end
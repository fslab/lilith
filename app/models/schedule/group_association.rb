class Schedule::GroupAssociation < ActiveRecord::Base
  include Lilith::UUIDHelper

  belongs_to :schedule
  belongs_to :group

  validates :group_id, :uniqueness => {:scope => :schedule_id}
end
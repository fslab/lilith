# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2011

This file is part of Lilith.

Lilith is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Lilith is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Lilith.  If not, see <http://www.gnu.org/licenses/>.
=end

# Topics of study units
class Course < ActiveRecord::Base
  include Lilith::UUIDHelper

  belongs_to :study_unit
  
  has_many :events, :dependent => :destroy do
    # All events which do not also belong to a group
    def exclusive(schedule_state = nil)
      params = {}
      params[:schedule_state_id] = schedule_state if schedule_state
      self.where(params) - self.where(params).joins(:group_associations)
    end
  end

  has_many :groups, :dependent => :destroy

  has_many :schedule_associations, class_name: 'Schedule::CourseAssociation', dependent: :destroy
  has_many :schedules, through: :schedule_associations
end
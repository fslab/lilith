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

require 'spec_helper'

describe Course do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:profile_url).of_type(:string) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should belong_to(:study_unit) }

  it { should have_many(:events) }

  context "#exclusive_events" do
    it "should only deliver events which aren't associated with a group" do
      group  = Group.make!
      course = group.course

      lone_event  = Event.make!(:course => course)
      group_event = Event.make!(:course => course)

      group_event.group_associations.create!(:group_id => group)

      result = course.events.exclusive
      result.should include(lone_event)
      result.should_not include(group_event)
    end
  end
end
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

require 'spec_helper'

describe Schedule do
  it { should have_db_column(:id) }

  it_should_behave_like "a timestamped model"
  
  it { should belong_to(:semester) }

  it { should have_many(:events) }

  context "default order" do
    it "should be ordered by updated_at in a descending way" do
      latest_schedule = described_class.make!(:updated_at => Time.new(2011, 5, 2, 3, 45))
      older_schedule = described_class.make!(:updated_at => Time.new(2011, 5, 1, 12))

      schedules = described_class.all
      schedules.first.should == latest_schedule
      schedules.last.should == older_schedule
    end
  end

  context "before destroy" do
    it "should destroy all its events" do
      schedule = described_class.make!

      events = [
        Event.make!(:schedule_id => schedule),
        Event.make!(:schedule_id => schedule)
      ]

      schedule.destroy

      events.each do |event|
        lambda {
          Event.find(event.id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context ".latest" do
    it "should always return the latest schedule" do
      latest_schedule = described_class.make!(:updated_at => Time.new(2011, 5, 2, 3, 45))
      older_schedule = described_class.make!(:updated_at => Time.new(2011, 5, 1, 12))

      described_class.latest.should == latest_schedule
    end
  end
end
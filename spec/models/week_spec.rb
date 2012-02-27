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

describe Week do
  it { should have_db_column(:id) }
  it { should have_db_column(:year).of_type(:integer) }
  it { should have_db_column(:index).of_type(:integer) }
  
  it_should_behave_like "a timestamped model"

  it { should have_many(:event_associations) }
  it { should have_many(:events) }

  context "before destroy" do
    it "should destroy all its event associations" do
      week = described_class.make!

      event_associations = [
        EventWeekAssociation.make!(:week_id => week),
        EventWeekAssociation.make!(:week_id => week)
      ]

      week.destroy

      event_associations.each do |association|
        lambda {
          EventWeekAssociation.find(association.id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context "#to_week" do
    it "should return the corresponding Aef::Weekling::Week object" do
      week = described_class.make(:year => 2011, :index => 25).to_week
      week.should == Aef::Weekling::Week.new(2011, 25)
    end
  end
end

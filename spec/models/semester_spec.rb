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

describe Semester do
  it { should have_db_column(:id) }
  it { should have_db_column(:season).of_type(:string) }
  it { should have_db_column(:start_year).of_type(:integer) }

  it_should_behave_like "a timestamped model"
  
  it { should have_many(:study_units) }
  it { should have_many(:schedule_states) }

  context "before destroy" do
    it "should destroy all its schedules" do
      semester = described_class.make!

      schedule_states = [
        ScheduleState.make!(:semester_id => semester),
        ScheduleState.make!(:semester_id => semester)
      ]

      semester.destroy

      schedule_states.each do |schedule|
        lambda {
          ScheduleState.find(schedule.id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "should destroy all its study units" do
      semester = described_class.make!

      study_units = [
        StudyUnit.make!(:semester_id => semester),
        StudyUnit.make!(:semester_id => semester)
      ]

      semester.destroy

      study_units.each do |study_unit|
        lambda {
          StudyUnit.find(study_unit.id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context ".find" do
    it "should find a semester by its UUID" do
      semester = Semester.make!

      Semester.find(semester.id).should == semester
    end

    it "should find a semester by its token" do
      semester = Semester.make!

      Semester.find(semester.token).should == semester
    end
  end

  context ".latest" do
    it "should find the latest semester based on season differences" do
      Semester.make!(:start_year => 2011, :season => :summer)
      winter_2011 = Semester.make!(:start_year => 2011, :season => :winter)

      Semester.latest.should == winter_2011 
    end

    it "should find the latest semester based on start year differences" do
      Semester.make!(:start_year => 2011, :season => :summer)
      Semester.make!(:start_year => 2011, :season => :winter)
      summer_2012 = Semester.make!(:start_year => 2012, :season => :summer)

      Semester.latest.should == summer_2012
    end
  end

  context "#name" do
    it "should produce correct names for winter semesters" do
      semester = Semester.make(:start_year => 2011, :season => :winter)

      semester.name.should == "WS 2011/2012"
    end

    it "should produce correct names for summer semesters" do
      semester = Semester.make(:start_year => 2012, :season => :summer)

      semester.name.should == "SS 2012"
    end
  end

  context "#token" do
    it "should produce correct names for winter semesters" do
      semester = Semester.make(:start_year => 2011, :season => :winter)

      semester.token.should == "2011w"
    end

    it "should produce correct names for summer semesters" do
      semester = Semester.make(:start_year => 2012, :season => :summer)

      semester.token.should == "2012s"
    end
  end

  context "#start_week" do
    it "should respond with correct Aef::Weekling::Week objects" do
      semester = Semester.make(:start_week => '2011-W43')

      semester.start_week.should == Aef::Weekling::Week.new(2011, 43)
    end

    it "should be settable with a String" do
      semester = Semester.make

      semester.start_week = '2011-W43'
      semester.save!

      semester = Semester.find(semester.id)
      semester.start_week.should == Aef::Weekling::Week.new(2011, 43)
    end

    it "should be settable with a Aef::Weekling::Week object" do
      semester = Semester.make

      semester.start_week = Aef::Weekling::Week.new(2011, 43)
      semester.save!

      semester = Semester.find(semester.id)
      semester.start_week.should == Aef::Weekling::Week.new(2011, 43)
    end
  end

  context "#end_week" do
    it "should respond with correct Aef::Weekling::Week objects" do
      semester = Semester.make(:end_week => '2011-W43')

      semester.end_week.should == Aef::Weekling::Week.new(2011, 43)
    end

    it "should be settable with a String" do
      semester = Semester.make

      semester.end_week = '2011-W43'
      semester.save!

      semester = Semester.find(semester.id)
      semester.end_week.should == Aef::Weekling::Week.new(2011, 43)
    end

    it "should be settable with a Aef::Weekling::Week object" do
      semester = Semester.make

      semester.end_week = Aef::Weekling::Week.new(2011, 43)
      semester.save!

      semester = Semester.find(semester.id)
      semester.end_week.should == Aef::Weekling::Week.new(2011, 43)
    end
  end

  context "#weeks" do
    it "should respond with a range of weeks" do
      semester = Semester.make(:start_week => '2011-W50', :end_week => '2012-W10')

      semester.weeks.should == (Aef::Weekling::Week.new(2011, 50) .. Aef::Weekling::Week.new(2012, 10)).to_a
    end
  end
end

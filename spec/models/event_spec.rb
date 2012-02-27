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

describe Event do
  it { should have_db_column(:id) }
  it { should have_db_column(:course_id) }
  it { should have_db_column(:schedule_state_id) }
  it { should have_db_column(:first_start).of_type(:datetime) }
  it { should have_db_column(:first_end).of_type(:datetime) }
  it { should have_db_column(:recurrence).of_type(:string) }
  it { should have_db_column(:until).of_type(:date) }

  it_should_behave_like "a timestamped model"

  it { should belong_to(:course) }
  it { should belong_to(:schedule_state) }

  it { should have_many(:group_associations) }
  it { should have_many(:groups) }
  it { should have_many(:category_associations) }
  it { should have_many(:categories) }
  it { should have_many(:lecturer_associations) }
  it { should have_many(:lecturers) }
  it { should have_many(:week_associations) }
  it { should have_many(:weeks) }

  context "before destroy" do
    it "should destroy all its group associations" do
      event = described_class.make!

      group_associations = [
        EventGroupAssociation.make!(:event_id => event),
        EventGroupAssociation.make!(:event_id => event)
      ]

      event.destroy

      group_associations.each do |association|
        lambda {
          EventGroupAssociation.find(association.id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "should destroy all its category associations" do
      event = described_class.make!

      category_associations = [
        CategoryEventAssociation.make!(:event_id => event),
        CategoryEventAssociation.make!(:event_id => event)
      ]

      event.destroy

      category_associations.each do |association|
        lambda {
          CategoryEventAssociation.find(association.id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "should destroy all its lecturer associations" do
      event = described_class.make!

      lecturer_associations = [
        EventLecturerAssociation.make!(:event_id => event),
        EventLecturerAssociation.make!(:event_id => event)
      ]

      event.destroy

      lecturer_associations.each do |association|
        lambda {
          EventGroupAssociation.find(association.id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "should destroy all its week associations" do
      event = described_class.make!

      week_associations = [
        EventWeekAssociation.make!(:event_id => event),
        EventWeekAssociation.make!(:event_id => event)
      ]

      event.destroy

      week_associations.each do |association|
        lambda {
          EventWeekAssociation.find(association.id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context "#occurences" do
    it "should report all occurrences as week day objects" do
      start_week_day = Aef::Weekling::WeekDay.new(2011, 14, :wednesday)

      event = Event.make!(
        :first_start => "#{start_week_day.to_date} 15:00",
        :first_end   => "#{start_week_day.to_date} 16:30"
      )
      
      (14..19).each do |week_index|
        event.weeks.create!(:year => 2011, :index => week_index)
      end

      semester = event.course.study_unit.semester
      semester.start_week = Aef::Weekling::Week.new(2011, 12)
      semester.end_week = Aef::Weekling::Week.new(2011, 25)
      semester.save!

      event.occurrences.should == [
        Aef::Weekling::WeekDay.new(2011, 14, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 15, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 16, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 17, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 18, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 19, start_week_day.to_sym)
      ]
    end

    it "should correctly remove holidays" do
      start_week_day = Aef::Weekling::WeekDay.new(2011, 16, :monday)

      event = Event.make!(
        :first_start => "#{start_week_day.to_date} 15:00",
        :first_end   => "#{start_week_day.to_date} 16:30"
      )

      (16..19).each do |week_index|
        event.weeks.create!(:year => 2011, :index => week_index)
      end

      semester = event.course.study_unit.semester
      semester.start_week = Aef::Weekling::Week.new(2011, 12)
      semester.end_week = Aef::Weekling::Week.new(2011, 25)
      semester.save!

      #Holiday would occur in week 17
      event.occurrences.should == [
        Aef::Weekling::WeekDay.new(2011, 16, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 18, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 19, start_week_day.to_sym)
      ]

    end
  end

  context "#exceptions" do
    it "should report all exceptions as week day objects" do
      start_week_day = Aef::Weekling::WeekDay.new(2011, 14, :wednesday)

      event = Event.make!(
        :first_start => "#{start_week_day.to_date} 15:00",
        :first_end   => "#{start_week_day.to_date} 16:30"
      )

      (14..19).each do |week_index|
        event.weeks.create!(:year => 2011, :index => week_index)
      end

      semester = event.course.study_unit.semester
      semester.start_week = Aef::Weekling::Week.new(2011, 12)
      semester.end_week = Aef::Weekling::Week.new(2011, 25)
      semester.save!

      event.exceptions.should == [
        Aef::Weekling::WeekDay.new(2011, 12, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 13, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 20, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 21, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 22, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 23, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 24, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 25, start_week_day.to_sym)
      ]
    end

    it "should correctly add holidays to the exceptions" do
      start_week_day = Aef::Weekling::WeekDay.new(2011, 16, :monday)

      event = Event.make!(
        :first_start => "#{start_week_day.to_date} 15:00",
        :first_end   => "#{start_week_day.to_date} 16:30"
      )

      (16..19).each do |week_index|
        event.weeks.create!(:year => 2011, :index => week_index)
      end

      semester = event.course.study_unit.semester
      semester.start_week = Aef::Weekling::Week.new(2011, 12)
      semester.end_week = Aef::Weekling::Week.new(2011, 25)
      semester.save!

      event.exceptions.should == [
        Aef::Weekling::WeekDay.new(2011, 12, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 13, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 14, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 15, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 17, start_week_day.to_sym), #Holiday.
        Aef::Weekling::WeekDay.new(2011, 20, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 21, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 22, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 23, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 24, start_week_day.to_sym),
        Aef::Weekling::WeekDay.new(2011, 25, start_week_day.to_sym)
      ]
    end
  end

end

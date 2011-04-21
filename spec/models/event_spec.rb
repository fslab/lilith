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
  it { should have_db_column(:first_start).of_type(:datetime) }
  it { should have_db_column(:first_end).of_type(:datetime) }
  it { should have_db_column(:recurrence).of_type(:string) }
  it { should have_db_column(:until).of_type(:date) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should belong_to(:course) }
  it { should belong_to(:schedule) }
  
  it { should have_many(:groups) }
  it { should have_many(:categories) }
  it { should have_many(:lecturers) }
  it { should have_many(:weeks) }

  context "#occurences" do
    it "should report all occurences as week day objects" do
      start_week_day = Aef::WeekDay.new(2011, 14, :wednesday)

      event = Event.make!(
        :first_start => "#{start_week_day.to_date} 15:00",
        :first_end   => "#{start_week_day.to_date} 16:30"
      )
      
      (14..19).each do |week_index|
        event.weeks.create!(:year => 2011, :index => week_index)
      end

      semester = event.course.study_unit.semester
      semester.start_week = Aef::Week.new(2011, 12)
      semester.end_week = Aef::Week.new(2011, 25)
      semester.save!

      event.occurences.should == [
        Aef::WeekDay.new(2011, 14, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 15, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 16, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 17, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 18, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 19, start_week_day.to_sym)
      ]
    end
  end

  context "#exceptions" do
    it "should report all exceptions as week day objects" do
      start_week_day = Aef::WeekDay.new(2011, 14, :wednesday)

      event = Event.make!(
        :first_start => "#{start_week_day.to_date} 15:00",
        :first_end   => "#{start_week_day.to_date} 16:30"
      )

      (14..19).each do |week_index|
        event.weeks.create!(:year => 2011, :index => week_index)
      end

      semester = event.course.study_unit.semester
      semester.start_week = Aef::Week.new(2011, 12)
      semester.end_week = Aef::Week.new(2011, 25)
      semester.save!

      event.exceptions.should == [
        Aef::WeekDay.new(2011, 12, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 13, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 20, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 21, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 22, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 23, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 24, start_week_day.to_sym),
        Aef::WeekDay.new(2011, 25, start_week_day.to_sym)
      ]
    end
  end

end
=begin encoding: UTF-8
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

describe Lilith::Week do
  context ".today" do
    it "should find the current week" do
      week = described_class.today
      today = Date.today

      week.year.should == today.year
      week.index.should == today.cweek
    end
  end

  context ".now" do
    it "should find the current week" do
      week = described_class.now
      today = Date.today

      week.year.should == today.year
      week.index.should == today.cweek
    end
  end

  context ".parse" do
    it "should recognize an ancient week" do
      week = described_class.parse('-1503-W50')

      week.year.should == -1503
      week.index.should == 50
    end

    it "should recognize a normal week" do
      week = described_class.parse('2011-W30')

      week.year.should == 2011
      week.index.should == 30
    end

    it "should recognize a post apocalyptic week" do
      week = described_class.parse('50023-W03')

      week.year.should == 50023
      week.index.should == 3
    end

    it "should report being unable to parse the given String" do
      lambda{
        described_class.parse('no week!')
      }.should raise_error(ArgumentError, 'No week found for parsing')
    end
  end

  context ".new" do
    it "should be able to initialize an ancient week by year and index" do
      week = described_class.new(-1691, 11)

      week.year.should == -1691
      week.index.should == 11
    end

    it "should be able to initialize a normal week by year and index" do
      week = described_class.new(2012, 40)

      week.year.should == 2012
      week.index.should == 40
    end

    it "should be able to initialize a post apocalyptic week by year and index" do
      week = described_class.new(23017, 29)

      week.year.should == 23017
      week.index.should == 29
    end

    it "should be able to initialize a week by a given date" do
      date = Date.today
      week = described_class.new(date)

      week.year.should == date.year
      week.index.should == date.cweek
    end

    it "should be able to initialize a week by a given date" do
      time = Time.now
      week = described_class.new(time)

      date = time.to_date

      week.year.should == date.year
      week.index.should == date.cweek
    end

    it "should accept week 53 for year in which one exists" do
      lambda{
        described_class.new(2015, 53)
      }.should_not raise_error
    end

    it "should report week 53 doesn't exist in the given year" do
      lambda{
        described_class.new(2011, 53)
      }.should raise_error(ArgumentError, /Index .* is invalid. Year .* has only 52 weeks/)
    end

    it "should always report if weeks below index 1 are given" do
      lambda{
        described_class.new(2011, 0)
      }.should raise_error(ArgumentError, /Index .* is invalid. Index can never be lower than 1 or higher than 53/)
    end

    it "should always report if weeks above index 53 are given" do
      lambda{
        described_class.new(2011, 54)
      }.should raise_error(ArgumentError, /Index .* is invalid. Index can never be lower than 1 or higher than 53/)
    end
  end

  context ".[]" do
    it "should be able to initialize an ancient week by year and index" do
      week = described_class[-1691, 11]

      week.year.should == -1691
      week.index.should == 11
    end

    it "should be able to initialize a normal week by year and index" do
      week = described_class[2012, 40]

      week.year.should == 2012
      week.index.should == 40
    end

    it "should be able to initialize a post apocalyptic week by year and index" do
      week = described_class[23017, 29]

      week.year.should == 23017
      week.index.should == 29
    end

    it "should be able to initialize a week by a given date" do
      date = Date.today
      week = described_class[date]

      week.year.should == date.year
      week.index.should == date.cweek
    end

    it "should be able to initialize a week by a given date" do
      time = Time.now
      week = described_class[time]

      date = time.to_date

      week.year.should == date.year
      week.index.should == date.cweek
    end
  end

  context "#== (type independent equality)" do
    it "should be true if year and index match" do
      week = described_class.new(2012, 1)
      other = described_class.new(2012, 1)

      week.should == other
    end

    it "should be true if year and index match, independent of the other object's type" do
      week = described_class.new(2012, 1)

      other = OpenStruct.new
      other.year = 2012
      other.index = 1

      week.should == other
    end

    it "should be false if year matches but not index" do
      week = described_class.new(2012, 1)
      other = described_class.new(2012, 13)

      week.should_not == other
    end

    it "should be false if year matches but not index, independent of the other object's type" do
      week = described_class.new(2012, 1)

      other = OpenStruct.new
      other.year = 2012
      other.index = 13

      week.should_not == other
    end

    it "should be false if index matches but not year" do
      week = described_class.new(2012, 1)
      other = described_class.new(2005, 1)

      week.should_not == other
    end

    it "should be false if index matches but not year, independent of the other object's type" do
      week = described_class.new(2012, 1)

      other = OpenStruct.new
      other.year = 2005
      other.index = 1

      week.should_not == other
    end

    it "should be false if both index and year do not match" do
      week = described_class.new(2012, 1)
      other = described_class.new(2005, 13)

      week.should_not == other
    end

    it "should be false if both index and year do not match, independent of the other object's type" do
      week = described_class.new(2012, 1)

      other = OpenStruct.new
      other.year = 2005
      other.index = 13

      week.should_not == other
    end
  end

  context "#eql? (type dependant equality)" do
    it "should be true if year and index and type matches and of same class" do
      week = described_class.new(2012, 1)
      other = described_class.new(2012, 1)

      week.should eql other
    end

    it "should be true if year and index and type matches and of inheriting class" do
      week = described_class.new(2012, 1)

      inheriting_class = Class.new(described_class)

      other = inheriting_class.new(2012, 1)

      week.should eql other
    end

    it "should be false if year and index match but type differs" do
      week = described_class.new(2012, 1)

      other = OpenStruct.new
      other.year = 2012
      other.index = 1

      week.should_not eql other
    end

    it "should be false if year matches but not index" do
      week = described_class.new(2012, 1)
      other = described_class.new(2012, 13)

      week.should_not eql other
    end

    it "should be false if index matches but not year" do
      week = described_class.new(2012, 1)
      other = described_class.new(2005, 1)

      week.should_not eql other
    end

    it "should be false if both index and year do not match" do
      week = described_class.new(2012, 1)
      other = described_class.new(2005, 13)

      week.should_not eql other
    end
  end

  context "#<=>" do
    it "should correctly determine the order of weeks based on year" do
      lower_week = described_class.new(2011, 14)
      higher_week = described_class.new(2012, 14)

      lower_week.should < higher_week
    end

    it "should correctly determine the order of weeks based on year, independent of type" do
      lower_week = described_class.new(2011, 14)
      
      higher_week = OpenStruct.new
      higher_week.year = 2012
      higher_week.index = 14

      lower_week.should < higher_week
    end

    it "should correctly determine the order of weeks based on index" do
      lower_week = described_class.new(2011, 14)
      higher_week = described_class.new(2011, 15)

      lower_week.should < higher_week
    end

    it "should correctly determine the order of weeks based on index, independent of type" do
      lower_week = described_class.new(2011, 14)

      higher_week = OpenStruct.new
      higher_week.year = 2011
      higher_week.index = 15

      lower_week.should < higher_week
    end

    it "should prioritize the order years when determining the order of weeks" do
      lower_week = described_class.new(2011, 14)
      higher_week = described_class.new(2012, 13)

      lower_week.should < higher_week
    end

    it "should prioritize the order years when determining the order of weeks, independent of type" do
      lower_week = described_class.new(2011, 14)

      higher_week = OpenStruct.new
      higher_week.year = 2012
      higher_week.index = 13

      lower_week.should < higher_week
    end
  end

  context "#to_s" do
    it "should be able to display an ancient week" do
      week = described_class.new(-1503, 50)

      week.to_s.should == '-1503-W50'
    end

    it "should be able to display a normal week" do
      week = described_class.new(2011, 30)

      week.to_s.should == '2011-W30'
    end

    it "should be able to display a post apocalyptic week" do
      week = described_class.new(50023, 3)

      week.to_s.should == '50023-W03'
    end   
  end

  context "#next" do
    it "should return the next week" do
      described_class.new(2011, 19).next.should == described_class.new(2011, 20)
    end

    it "should return the next week at the end of a year" do
      described_class.new(2011, 52).next.should == described_class.new(2012, 1)
    end

    it "should return the next week one week before the end of a year with 53 weeks" do
      described_class.new(2015, 52).next.should == described_class.new(2015, 53)
    end

    it "should return the next week at the end of a year with 53 weeks" do
      described_class.new(2015, 53).next.should == described_class.new(2016, 1)
    end
  end
  
  context "#succ" do
    it "should return the succ week" do
      described_class.new(2011, 19).succ.should == described_class.new(2011, 20)
    end

    it "should return the succ week at the end of a year" do
      described_class.new(2011, 52).succ.should == described_class.new(2012, 1)
    end

    it "should return the succ week one week before the end of a year with 53 weeks" do
      described_class.new(2015, 52).succ.should == described_class.new(2015, 53)
    end

    it "should return the succ week at the end of a year with 53 weeks" do
      described_class.new(2015, 53).succ.should == described_class.new(2016, 1)
    end
  end

  context "#previous" do
    it "should return the previous week" do
      described_class.new(2011, 20).previous.should == described_class.new(2011, 19)
    end

    it "should return the previous week at the beginning of a year" do
      described_class.new(2012, 1).previous.should == described_class.new(2011, 52)
    end

    it "should return the previous week at the beginning of a year after one with 53 weeks" do
      described_class.new(2016, 1).previous.should == described_class.new(2015, 53)
    end

    it "should return the previous week at the end of a year with 53 weeks" do
      described_class.new(2015, 53).previous.should == described_class.new(2015, 52)
    end
  end
  
  context "#pred" do
    it "should return the pred week" do
      described_class.new(2011, 20).pred.should == described_class.new(2011, 19)
    end

    it "should return the pred week at the beginning of a year" do
      described_class.new(2012, 1).pred.should == described_class.new(2011, 52)
    end

    it "should return the pred week at the beginning of a year after one with 53 weeks" do
      described_class.new(2016, 1).pred.should == described_class.new(2015, 53)
    end

    it "should return the pred week at the end of a year with 53 weeks" do
      described_class.new(2015, 53).pred.should == described_class.new(2015, 52)
    end
  end
end
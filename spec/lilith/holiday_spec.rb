require 'spec_helper'
require 'lilith'
require 'lilith/holiday'

describe Lilith::Holiday do
  context "#<=>" do
    it "should correctly report being lesser than an other object?" do
      lesser_holiday = described_class.new(2011,1,1,'Neujahr')
      greater_holiday = described_class.new(2011,5,1,'Tag der Arbeit')
      (lesser_holiday <=> greater_holiday).should == -1
    end

    it "should correctly report being greater than an other object?" do
      lesser_holiday = described_class.new(2011,1,1,'Neujahr')
      greater_holiday = described_class.new(2011,5,1,'Tag der Arbeit')
      (greater_holiday <=> lesser_holiday).should == 1
    end

    it "should correctly report being equal to another object?" do
      holiday = described_class.new(2011,1,1,'Neujahr')
      (holiday <=> holiday).should == 0
    end
  end

  context "#==" do
    it "should equal independent of type" do
      date = Date.new(2011, 5, 1)
      holiday = described_class.new(2011,5,1,'Tag der Arbeit')
      holiday.should == date
    end
  end

  context "#eql?" do
    it "should report equality correctly if type matches" do
      holiday_one = described_class.new(2011,1,1,'Neujahr')
      holiday_two = described_class.new(2011,1,1,'Neujahr')
      holiday_one.should eql(holiday_two)
    end

    it "should report equality correctly if type doesn't match" do
      date = Date.new(2011, 5, 1)
      holiday = described_class.new(2011,5,1,'Tag der Arbeit')
      holiday.should_not eql(date)
    end

  end
end


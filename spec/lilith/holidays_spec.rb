require 'spec_helper'

describe Holidays do
  context "fixed holidays" do
    (2011..2020).each do |year|
      it "should correctly find Neujahr for #{year}"  do
        holidays = described_class.new(year)
        holiday = holidays.find('Neujahr')
        holiday.year.should == year
        holiday.month.should == 1
        holiday.day.should == 1
        holiday.name.should == 'Neujahr'
      end

       it "should correctly find Tag der Arbeit for #{year}"  do
        holidays = described_class.new(year)
        holiday = holidays.find('Tag der Arbeit')
        holiday.year.should == year
        holiday.month.should == 5
        holiday.day.should == 1
        holiday.name.should == 'Tag der Arbeit'
       end

       it "should correctly find Tag der Arbeit for #{year}"  do
        holidays = described_class.new(year)
        holiday = holidays.find('Tag der Arbeit')
        holiday.year.should == year
        holiday.month.should == 5
        holiday.day.should == 1
        holiday.name.should == 'Tag der Arbeit'
       end

       it "should correctly find Tag der Arbeit for #{year}"  do
        holidays = described_class.new(year)
        holiday = holidays.find('Tag der Arbeit')
        holiday.year.should == year
        holiday.month.should == 5
        holiday.day.should == 1
        holiday.name.should == 'Tag der Arbeit'
      end
    end
  end
end
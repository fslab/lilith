require 'spec_helper'
require 'lilith'
require 'lilith/holiday_list'

describe Lilith::HolidayList do
  context "in 2012" do
    before(:each) do
      @year = 2012
    end

    context ".for" do
      it "should instantiate a HolidayList Object for #{@year}" do
        holiday_list = described_class.for(@year)

        holiday_list.should be_a(Lilith::HolidayList)
        holiday_list.year.should == @year
      end

      it "should correctly behave like a multiton" do
        holiday_list_first = described_class.for(@year)
        holiday_list_second = described_class.for(@year)

        holiday_list_first.object_id.should == holiday_list_second.object_id
      end
    end

    context "#find" do
      it "should find a holiday by name" do
        holidays = described_class.new(@year)
        holidays.find('Ostersonntag').name.should == 'Ostersonntag'
      end

      it "should return an enumerator if no argument is given" do
        holidays = described_class.new(@year)
        holidays.find.should be_a Enumerator
      end

      it "should find a name via a block as argument" do
        holidays = described_class.new(@year)
        holidays.find{|element| element.name == 'Ostersonntag'}.name.should == 'Ostersonntag'
      end
    end

    it "should return all holidays" do
      holidays = described_class.new(@year)
      holidays.holidays.map(&:name).to_set.should == Set.new([
        "Neujahr",
        "Karfreitag",
        "Ostersonntag",
        "Ostermontag",
        "Fronleichnam",
        "Tag der Arbeit",
        "Christi Himmelfahrt",
        "Pfingstmontag",
        "Allerheiligen",
        "Tag der deutschen Einheit",
        "1. Weihnachtsfeiertag",
        "2. Weihnachtsfeiertag"
      ])
    end

    it "should correctly find Ostersonntag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Ostersonntag')
      Aef::WeekDay.new(holiday).should be_sunday
      holiday.year.should == @year
      holiday.month.should == 4
      holiday.day.should == 8
      holiday.name.should == 'Ostersonntag'
    end

    it "should correctly find Karfreitag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Karfreitag')
      Aef::WeekDay.new(holiday).should be_friday
      holiday.year.should == @year
      holiday.month.should == 4
      holiday.day.should == 6
      holiday.name.should == 'Karfreitag'
    end

    it "should correctly find Ostermontag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Ostermontag')
      Aef::WeekDay.new(holiday).should be_monday
      holiday.year.should == @year
      holiday.month.should == 4
      holiday.day.should == 9
      holiday.name.should == 'Ostermontag'
    end

    it "should correctly find Christi Himmelfahrt for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Christi Himmelfahrt')
      holiday.year.should == @year
      holiday.month.should == 5
      holiday.day.should == 17
      holiday.name.should == 'Christi Himmelfahrt'
    end

    it "should correctly find Pfingstmontag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Pfingstmontag')
      holiday.year.should == @year
      holiday.month.should == 5
      holiday.day.should == 28
      holiday.name.should == 'Pfingstmontag'
    end
      it "should correctly find Fronleichnam for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Fronleichnam')
      holiday.year.should == @year
      holiday.month.should == 6
      holiday.day.should == 7
      holiday.name.should == 'Fronleichnam'
    end
  end

  context "in 2014" do
    before(:each) do
        @year = 2014
    end

    it "should correctly find Ostersonntag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Ostersonntag')
      Aef::WeekDay.new(holiday).should be_sunday
      holiday.year.should == @year
      holiday.month.should == 4
      holiday.day.should == 20
      holiday.name.should == 'Ostersonntag'
    end

    it "should correctly find Karfreitag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Karfreitag')
      Aef::WeekDay.new(holiday).should be_friday
      holiday.year.should == @year
      holiday.month.should == 4
      holiday.day.should == 18
      holiday.name.should == 'Karfreitag'
    end

    it "should correctly find Ostermontag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Ostermontag')
      Aef::WeekDay.new(holiday).should be_monday
      holiday.year.should == @year
      holiday.month.should == 4
      holiday.day.should == 21
      holiday.name.should == 'Ostermontag'
    end

    it "should correctly find Christi Himmelfahrt for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Christi Himmelfahrt')
      holiday.year.should == @year
      holiday.month.should == 5
      holiday.day.should == 29
      holiday.name.should == 'Christi Himmelfahrt'
    end

    it "should correctly find Pfingstmontag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Pfingstmontag')
      holiday.year.should == @year
      holiday.month.should == 6
      holiday.day.should == 9
      holiday.name.should == 'Pfingstmontag'
    end
    it "should correctly find Fronleichnam for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Fronleichnam')
      holiday.year.should == @year
      holiday.month.should == 6
      holiday.day.should == 19
      holiday.name.should == 'Fronleichnam'
    end
  end

  context "in 2013" do
    before(:each) do
        @year = 2013
    end

    it "should correctly find Ostersonntag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Ostersonntag')
      Aef::WeekDay.new(holiday).should be_sunday
      holiday.year.should == @year
      holiday.month.should == 3
      holiday.day.should == 31
      holiday.name.should == 'Ostersonntag'
    end

    it "should correctly find Karfreitag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Karfreitag')
      Aef::WeekDay.new(holiday).should be_friday
      holiday.year.should == @year
      holiday.month.should == 3
      holiday.day.should == 29
      holiday.name.should == 'Karfreitag'
    end

    it "should correctly find Ostermontag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Ostermontag')
      Aef::WeekDay.new(holiday).should be_monday
      holiday.year.should == @year
      holiday.month.should == 4
      holiday.day.should == 1
      holiday.name.should == 'Ostermontag'
    end

    it "should correctly find Christi Himmelfahrt for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Christi Himmelfahrt')
      holiday.year.should == @year
      holiday.month.should == 5
      holiday.day.should == 9
      holiday.name.should == 'Christi Himmelfahrt'
    end

    it "should correctly find Pfingstmontag for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Pfingstmontag')
      holiday.year.should == @year
      holiday.month.should == 5
      holiday.day.should == 20
      holiday.name.should == 'Pfingstmontag'
    end

    it "should correctly find Fronleichnam for #{@year}"  do
      holidays = described_class.new(@year)
      holiday = holidays.find('Fronleichnam')
      holiday.year.should == @year
      holiday.month.should == 5
      holiday.day.should == 30
      holiday.name.should == 'Fronleichnam'
    end
  end

  context "fixed holidays" do
    (2011..2015).each do |year|
      it "should correctly find Neujahr for #{year}"  do
        holidays = described_class.new(year)
        holiday = holidays.find('Neujahr')
        holiday.year.should == year
        holiday.month.should == 1
        holiday.day.should == 1
        holiday.name.should == 'Neujahr'
      end

      it "should correctly find Tag der deutschen Einheit for #{year}"  do
        holidays = described_class.new(year)
        holiday = holidays.find('Tag der deutschen Einheit')
        holiday.year.should == year
        holiday.month.should == 10
        holiday.day.should == 3
        holiday.name.should == 'Tag der deutschen Einheit'
      end

      it "should correctly find Tag der Arbeit for #{year}"  do
        holidays = described_class.new(year)
        holiday = holidays.find('Tag der Arbeit')
        holiday.year.should == year
        holiday.month.should == 5
        holiday.day.should == 1
        holiday.name.should == 'Tag der Arbeit'
      end

      it "should correctly find Allerheiligen for #{year}"  do
        holidays = described_class.new(year)
        holiday = holidays.find('Allerheiligen')
        holiday.year.should == year
        holiday.month.should == 11
        holiday.day.should == 1
        holiday.name.should == 'Allerheiligen'
      end

      it "should correctly find 1. Weihnachtsfeiertag for #{year}"  do
        holidays = described_class.new(year)
        holiday = holidays.find('1. Weihnachtsfeiertag')
        holiday.year.should == year
        holiday.month.should == 12
        holiday.day.should == 25
        holiday.name.should == '1. Weihnachtsfeiertag'
      end

      it "should correctly find 2. Weihnachtsfeiertag for #{year}"  do
        holidays = described_class.new(year)
        holiday = holidays.find('2. Weihnachtsfeiertag')
        holiday.year.should == year
        holiday.month.should == 12
        holiday.day.should == 26
        holiday.name.should == '2. Weihnachtsfeiertag'
      end
    end
  end
end
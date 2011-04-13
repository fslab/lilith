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
require 'lilith/hbrs_eva_scraper'
require 'lilith/mock_agent'

describe Lilith::HbrsEvaScraper do
  fixtures_dir =  Rails.root + 'spec' + 'fixtures'
  MENU_FILE = fixtures_dir + '2011-03-24_menu.html'
  PLAN_FILE = fixtures_dir + '2011-03-24_bcs4.html'

  before(:each) do
    @scraper = described_class.new(
      :agent  => Lilith::MockAgent.new(:mock_document_file => MENU_FILE),
      :logger => Logger.new(nil)
    )
  end

  it "should find 16 study units in the fixture file" do
    semester = Semester.make(:start_week => '2011-W12', :start_week => '2011-W25')

    @scraper.scrape_study_units(semester).should have(16).items
  end

  context "#scrape_week_associations" do
    before(:each) do
      semester = Semester.make(
        :start_year => 2011,
        :season     => :summer,
        :start_week => '2011-W12',
        :end_week   => '2011-W25'
      )

      @event = Event.make(:recurrence => nil)
      study_unit = @event.course.study_unit
      study_unit.semester = semester
      study_unit.save!
    end

    it "should be able to scrape 'KW 12-25'" do
      @scraper.scrape_week_associations(@event, 'KW 12-25')

      expected_weeks = (Lilith::Week.new(2011, 12) .. Lilith::Week.new(2011, 25)).to_a

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 13-25'" do
      @scraper.scrape_week_associations(@event, 'KW 13-25')

      expected_weeks = (Lilith::Week.new(2011, 13) .. Lilith::Week.new(2011, 25)).to_a

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 12-24'" do
      @scraper.scrape_week_associations(@event, 'KW 12-24')

      expected_weeks = (Lilith::Week.new(2011, 12) .. Lilith::Week.new(2011, 24)).to_a

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 20-25'" do
      @scraper.scrape_week_associations(@event, 'KW 20-25')

      expected_weeks = (Lilith::Week.new(2011, 20) .. Lilith::Week.new(2011, 25)).to_a

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 13-18'" do
      @scraper.scrape_week_associations(@event, 'KW 13-18')

      expected_weeks = (Lilith::Week.new(2011, 13) .. Lilith::Week.new(2011, 18)).to_a

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 12,13,15,17,19,21,23'" do
      @scraper.scrape_week_associations(@event, 'KW 12,13,15,17,19,21,23')

      expected_weeks = [12, 13, 15, 17, 19, 21, 23].map{|index| Lilith::Week.new(2011, index) }

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 14,15,17,18'" do
      @scraper.scrape_week_associations(@event, 'KW 14,15,17,18')

      expected_weeks = [14, 15, 17, 18].map{|index| Lilith::Week.new(2011, index) }

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 13,9,21'" do
      @scraper.scrape_week_associations(@event, 'KW 13,9,21')

      expected_weeks = [9, 13, 21].map{|index| Lilith::Week.new(2011, index) }

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 16'" do
      @scraper.scrape_week_associations(@event, 'KW 16')

      expected_weeks = [Lilith::Week.new(2011, 16)]

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'uKW'" do
      @scraper.scrape_week_associations(@event, 'uKW')

      expected_weeks = [13, 15, 17, 19, 21, 23, 25].map{|index| Lilith::Week.new(2011, index) }

      @event.recurrence.should == 'uKW'
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'uKW ab KW 15'" do
      @scraper.scrape_week_associations(@event, 'uKW ab KW 15')

      expected_weeks = [15, 17, 19, 21, 23, 25].map{|index| Lilith::Week.new(2011, index) }

      @event.recurrence.should == 'uKW'
      @event.weeks.map(&:to_week).should == expected_weeks
    end


    it "should be able to scrape 'gKW'" do
      @scraper.scrape_week_associations(@event, 'gKW')

      expected_weeks = [12, 14, 16, 18, 20, 22, 24].map{|index| Lilith::Week.new(2011, index) }

      @event.recurrence.should == 'gKW'
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'gKW ab KW 14'" do
      @scraper.scrape_week_associations(@event, 'gKW ab KW 14')

      expected_weeks = [14, 16, 18, 20, 22, 24].map{|index| Lilith::Week.new(2011, index) }

      @event.recurrence.should == 'gKW'
      @event.weeks.map(&:to_week).should == expected_weeks
    end
  end

  context ".parse_range" do
    it "should be able to parse '16'" do
      described_class.parse_range('16').should == %w{16}
    end

    it "should be able to parse '13,9,21'" do
      described_class.parse_range('13,9,21').should == %w{13 9 21}
    end

    it "should be able to parse '14,15,17,18'" do
      described_class.parse_range('14,15,17,18').should == %w{14 15 17 18}
    end

    it "should be able to parse '12,13,15,17,19,21,23'" do
      described_class.parse_range('12,13,15,17,19,21,23').should == %w{12 13 15 17 19 21 23}
    end

    it "should be able to parse '13-18'" do
      described_class.parse_range('13-18').should == ['13'..'18']
    end

    it "should be able to parse '20-25'" do
      described_class.parse_range('20-25').should == ['20'..'25']
    end

    it "should be able to parse '12-24'" do
      described_class.parse_range('12-24').should == ['12'..'24']
    end

    it "should be able to parse '13-25'" do
      described_class.parse_range('13-25').should == ['13'..'25']
    end
  end

  context ".parse_week_range" do
    before(:each) do
      @semester = Semester.make(:start_week => '2011-W12', :end_week => '2011-W25')
    end

    it "should be able to parse '13+14'" do
      semester = Semester.make(:start_week => '2011-W10', :end_week => '2011-W24')

      expected_weeks = [13, 14].map{|index| Lilith::Week.new(2011, index)}

      described_class.parse_week_range(semester, '13+14').should == expected_weeks
    end

    it "should be able to parse '13 + 14 '" do
      semester = Semester.make(:start_week => '2011-W10', :end_week => '2011-W24')

      expected_weeks = [13, 14].map{|index| Lilith::Week.new(2011, index)}

      described_class.parse_week_range(semester, '13 + 14 ').should == expected_weeks
    end

    it "should be able to parse '12-25'" do
      expected_weeks = (12..25).map{|index| Lilith::Week.new(2011, index)}

      described_class.parse_week_range(@semester, '12-25').should == expected_weeks
    end

    it "should be able to parse ' 12 - 25'" do
      expected_weeks = (12..25).map{|index| Lilith::Week.new(2011, index)}

      described_class.parse_week_range(@semester, ' 12 - 25').should == expected_weeks
    end

    it "should be able to parse '12,14,15,17'" do
      semester = Semester.make(:start_week => '2011-W10', :end_week => '2011-W24')

      expected_weeks = [12, 14, 15, 17].map{|index| Lilith::Week.new(2011, index)}

      described_class.parse_week_range(semester, '12,14,15,17').should == expected_weeks
    end

    it "should be able to parse '12, 14,15 , 17'" do
      semester = Semester.make(:start_week => '2011-W10', :end_week => '2011-W24')
      
      expected_weeks = [12, 14, 15, 17].map{|index| Lilith::Week.new(2011, index)}

      described_class.parse_week_range(semester, '12, 14,15 , 17').should == expected_weeks
    end

    it "should be able to parse '49-51,1+3'" do
      semester = Semester.make(:start_week => '2011-W44', :end_week => '2012-W06')

      expected_weeks = []
      expected_weeks += [49, 50, 51].map{|index| Lilith::Week.new(2011, index)}
      expected_weeks += [1, 3].map{|index| Lilith::Week.new(2012, index)}

      described_class.parse_week_range(semester, '49-51,1+3').should == expected_weeks
    end

    it "should be able to parse 'ab KW 15'" do
      semester = Semester.make(:start_week => '2011-W12', :end_week => '2011-W25')

      expected_weeks = (15..25).map{|index| Lilith::Week.new(2011, index)}

      described_class.parse_week_range(semester, 'ab KW 15').should == expected_weeks
    end

    it "should be able to parse '16'" do
      expected_weeks = [Lilith::Week.new(2011, 16)]

      described_class.parse_week_range(@semester, '16').should == expected_weeks
    end

    it "should be able to parse '13,9,21'" do
      expected_weeks = [13, 9, 21].map{|index| Lilith::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '13,9,21').should == expected_weeks
    end

    it "should be able to parse '14,15,17,18'" do
      expected_weeks = [14, 15, 17, 18].map{|index| Lilith::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '14,15,17,18').should == expected_weeks
    end

    it "should be able to parse '12,13,15,17,19,21,23'" do
      expected_weeks = [12, 13, 15, 17, 19, 21, 23].map{|index| Lilith::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '12,13,15,17,19,21,23').should == expected_weeks
    end

    it "should be able to parse '13-18'" do
      expected_weeks = (13..18).map{|index| Lilith::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '13-18').should == expected_weeks
    end

    it "should be able to parse '20-25'" do
      expected_weeks = (20..25).map{|index| Lilith::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '20-25').should == expected_weeks
    end

    it "should be able to parse '12-24'" do
      expected_weeks = (12..24).map{|index| Lilith::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '12-24').should == expected_weeks
    end

    it "should be able to parse '13-25'" do
      expected_weeks = (13..25).map{|index| Lilith::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '13-25').should == expected_weeks
    end
  end
end
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
    semester = Semester.make

    @scraper = described_class.new(semester)
  end

  it "should find 16 study units in the fixture file" do
    @scraper.agent = Lilith::MockAgent.new(:mock_document_file => MENU_FILE)

    semester = Semester.make(:start_week => '2011-W12', :start_week => '2011-W25')

    @scraper.scrape_study_units(semester).should have(16).items
  end

  context ".parse_week_range" do
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
      semester = Semester.make(:start_week => '2011-W12', :end_week => '2011-W25')
      
      expected_weeks = (12..25).map{|index| Lilith::Week.new(2011, index)}

      described_class.parse_week_range(semester, '12-25').should == expected_weeks
    end

    it "should be able to parse ' 12 - 25'" do
      semester = Semester.make(:start_week => '2011-W12', :end_week => '2011-W25')

      expected_weeks = (12..25).map{|index| Lilith::Week.new(2011, index)}

      described_class.parse_week_range(semester, ' 12 - 25').should == expected_weeks
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
  end
end
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

describe Lilith::HbrsEvaScraper do
  fixtures_dir =  Rails.root + 'spec' + 'fixtures'
  MENU_FILE = fixtures_dir + '2011-03-24_menu.html'
  PLAN_FILE = fixtures_dir + '2011-03-24_bcs4.html'

  before(:each) do
    study_unit_page = Object.new
    study_unit_page.stub(:search) {|*args| Nokogiri.parse(PLAN_FILE.read).search(*args) }
    menu_page_form = {}
    menu_page_form.stub(:submit) { study_unit_page }
    menu_page = Object.new
    menu_page.stub(:forms) { [menu_page_form] }
    menu_page.stub(:search) {|*args| Nokogiri.parse(MENU_FILE.read).search(*args) }
    agent = Object.new
    agent.stub(:get) { menu_page }
    
    @scraper = described_class.new(
      :agent  => agent,
      :logger => Logger.new(nil)
    )
  end


  it "should find 16 study units in the fixture file" do
    semester = Semester.make(:start_week => '2011-W12', :start_week => '2011-W25')

    @scraper.scrape_study_units(semester).should have(16).items
  end


  context "#menu_page" do
    it "should return the correct page object" do
      /Timetable/.should match(@scraper.menu_page.search('//h1').first.text)
    end
  end

  context "#week_numbers" do
    it "should contain all current week numbers" do
      @scraper.week_numbers.should == (12..25).map(&:to_s)
    end
  end

  context "#study_units" do
    it "should contain all study units" do
      @scraper.study_units.should == {
        'B BIS 2' => 'BBIS2',
        'B BIS 4' => 'BBIS4',
        'B BIS 6' => '#SPLUS889420',
        'B CS 2' => 'BCS2',
        'B CS 4' => 'BCS4',
        'B CS 6' => 'BCS6',
        'B CS(TZ) 2' => '#SPLUS29CFBB',
        'B CS(TZ) 4' => '#SPLUSEEF90F',
        'B CS(TZ) 8' => '#SPLUS6F1449',
        'M AS 1' => 'MAS1',
        'M AS 2' => 'MAS2',
        'M AS 3' => 'MAS3',
        'M CS 1' => 'MCS1',
        'M CS 2' => 'MCS2',
        'M CS 3' => 'MCS3',
        'M KSN 2' => '#SPLUS4222DA',
      }
    end
  end

  context "#study_unit_page" do
    it "should return the correct page object" do
      page = @scraper.study_unit_page('BCS4')

      /Timetable of Semester B CS 4/.should match(page.search('//h1').first.text)
    end
  end

  context "#scrape_semester" do
    it "should persist the correct semester" do
      semester = @scraper.scrape_semester
      semester.start_year.should == 2011
      semester.season.should == :summer
    end

    it "should correctly set the week range" do
      semester = @scraper.scrape_semester
      semester.start_week.should == Aef::Week.new(2011, 12)
      semester.end_week.should   == Aef::Week.new(2011, 25)
    end
  end

  context "#scrape_study_units" do
    it "should perist all study units" do
      study_units = @scraper.scrape_study_units(Semester.make!)
      study_units.map{|study_unit| study_unit.attributes.slice('program', 'position')}.to_set.should == [
        {'program' => 'Bachelor BIS', 'position' => 2},
        {'program' => 'Bachelor BIS', 'position' => 4},
        {'program' => 'Bachelor BIS', 'position' => 6},
        {'program' => 'Bachelor CS', 'position' => 2},
        {'program' => 'Bachelor CS', 'position' => 4},
        {'program' => 'Bachelor CS', 'position' => 6},
        {'program' => 'Bachelor CS(TZ)', 'position' => 2},
        {'program' => 'Bachelor CS(TZ)', 'position' => 4},
        {'program' => 'Bachelor CS(TZ)', 'position' => 8},
        {'program' => 'Master AS', 'position' => 1},
        {'program' => 'Master AS', 'position' => 2},
        {'program' => 'Master AS', 'position' => 3},
        {'program' => 'Master CS', 'position' => 1},
        {'program' => 'Master CS', 'position' => 2},
        {'program' => 'Master CS', 'position' => 3},
        {'program' => 'Master KSN', 'position' => 2}
      ].to_set
    end
  end

  context "#scrape_group_associations" do
    before(:each) do
      @event = Event.make!
    end

    it "should be able to scrape '3'" do
      @scraper.scrape_group_associations(@event, '3')

      @event.groups.map(&:name).to_set.should == %w{3}.to_set
    end

    it "should be able to scrape ' 3 '" do
      @scraper.scrape_group_associations(@event, ' 3 ')

      @event.groups.map(&:name).to_set.should == %w{3}.to_set
    end

    it "should be able to scrape '3+TZ'" do
      @scraper.scrape_group_associations(@event, '3+TZ')

      @event.groups.map(&:name).to_set.should == %w{3 TZ}.to_set
    end

    it "should be able to scrape '1-3+TZ'" do
      @scraper.scrape_group_associations(@event, '1-3+TZ')

      @event.groups.map(&:name).to_set.should == %w{1 2 3 TZ}.to_set
    end

    it "should be able to scrape '4-7'" do
      @scraper.scrape_group_associations(@event, '4-7')

      @event.groups.map(&:name).to_set.should == %w{4 5 6 7}.to_set
    end

    it "should be able to scrape '3+4'" do
      @scraper.scrape_group_associations(@event, '3+4')

      @event.groups.map(&:name).to_set.should == %w{3 4}.to_set
    end
  end

  context "#scrape_lecturer_associations" do
    before(:each) do
      @event = Event.make!
    end

    it "should be able to scrape a single lecturers" do
      @scraper.scrape_lecturer_associations(@event, 'Richards')

      @event.lecturers.map(&:eva_id).to_set.should == %w{Richards}.to_set
    end

    it "should be able to scrape multiple lecturers" do
      @scraper.scrape_lecturer_associations(@event, 'von_der_Zwuckelheide, Yoko-Keil')

      @event.lecturers.map(&:eva_id).to_set.should == %w{von_der_Zwuckelheide Yoko-Keil}.to_set
    end

    it "should be able to scrape a single lecturers with a comma in his id" do
      @scraper.scrape_lecturer_associations(@event, 'Plan,K.')

      @event.lecturers.map(&:eva_id).to_set.should == %w{Plan,K.}.to_set
    end

    it "should be able to scrape a single lecturers with a comma in his id out of multiple" do
      @scraper.scrape_lecturer_associations(@event, 'Plan,K., Richards')

      @event.lecturers.map(&:eva_id).to_set.should == %w{Plan,K. Richards}.to_set
    end
  end

  context "#scrape_category_associations" do
    before(:each) do
      @event = Event.make!
    end

    it "should be able to scrape 'V'" do
      @scraper.scrape_category_associations(@event, 'V')

      @event.categories.map(&:eva_id).to_set.should == %w{V}.to_set
    end

    it "should be able to scrape 'Ü'" do
      @scraper.scrape_category_associations(@event, 'Ü')

      @event.categories.map(&:eva_id).to_set.should == %w{Ü}.to_set
    end

    it "should be able to scrape 'VÜP'" do
      @scraper.scrape_category_associations(@event, 'VÜP')

      @event.categories.map(&:eva_id).to_set.should == %w{V Ü P}.to_set
    end

    it "should be able to scrape 'Ü/P'" do
      @scraper.scrape_category_associations(@event, 'Ü/P')

      @event.categories.map(&:eva_id).to_set.should == %w{Ü P}.to_set
    end

    it "should not scrape 'Projekt'" do
      @scraper.scrape_category_associations(@event, 'Projekt')

      @event.categories.map(&:eva_id).to_set.should == [].to_set
    end
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

      expected_weeks = (Aef::Week.new(2011, 12) .. Aef::Week.new(2011, 25)).to_a

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 13-25'" do
      @scraper.scrape_week_associations(@event, 'KW 13-25')

      expected_weeks = (Aef::Week.new(2011, 13) .. Aef::Week.new(2011, 25)).to_a

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 12-24'" do
      @scraper.scrape_week_associations(@event, 'KW 12-24')

      expected_weeks = (Aef::Week.new(2011, 12) .. Aef::Week.new(2011, 24)).to_a

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 20-25'" do
      @scraper.scrape_week_associations(@event, 'KW 20-25')

      expected_weeks = (Aef::Week.new(2011, 20) .. Aef::Week.new(2011, 25)).to_a

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 13-18'" do
      @scraper.scrape_week_associations(@event, 'KW 13-18')

      expected_weeks = (Aef::Week.new(2011, 13) .. Aef::Week.new(2011, 18)).to_a

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 12,13,15,17,19,21,23'" do
      @scraper.scrape_week_associations(@event, 'KW 12,13,15,17,19,21,23')

      expected_weeks = [12, 13, 15, 17, 19, 21, 23].map{|index| Aef::Week.new(2011, index) }

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 14,15,17,18'" do
      @scraper.scrape_week_associations(@event, 'KW 14,15,17,18')

      expected_weeks = [14, 15, 17, 18].map{|index| Aef::Week.new(2011, index) }

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 13,9,21'" do
      @scraper.scrape_week_associations(@event, 'KW 13,9,21')

      expected_weeks = [9, 13, 21].map{|index| Aef::Week.new(2011, index) }

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'KW 16'" do
      @scraper.scrape_week_associations(@event, 'KW 16')

      expected_weeks = [Aef::Week.new(2011, 16)]

      @event.recurrence.should be_nil
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'uKW'" do
      @scraper.scrape_week_associations(@event, 'uKW')

      expected_weeks = [13, 15, 17, 19, 21, 23, 25].map{|index| Aef::Week.new(2011, index) }

      @event.recurrence.should == 'uKW'
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'uKW ab KW 15'" do
      @scraper.scrape_week_associations(@event, 'uKW ab KW 15')

      expected_weeks = [15, 17, 19, 21, 23, 25].map{|index| Aef::Week.new(2011, index) }

      @event.recurrence.should == 'uKW'
      @event.weeks.map(&:to_week).should == expected_weeks
    end


    it "should be able to scrape 'gKW'" do
      @scraper.scrape_week_associations(@event, 'gKW')

      expected_weeks = [12, 14, 16, 18, 20, 22, 24].map{|index| Aef::Week.new(2011, index) }

      @event.recurrence.should == 'gKW'
      @event.weeks.map(&:to_week).should == expected_weeks
    end

    it "should be able to scrape 'gKW ab KW 14'" do
      @scraper.scrape_week_associations(@event, 'gKW ab KW 14')

      expected_weeks = [14, 16, 18, 20, 22, 24].map{|index| Aef::Week.new(2011, index) }

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

      expected_weeks = [13, 14].map{|index| Aef::Week.new(2011, index)}

      described_class.parse_week_range(semester, '13+14').should == expected_weeks
    end

    it "should be able to parse '13 + 14 '" do
      semester = Semester.make(:start_week => '2011-W10', :end_week => '2011-W24')

      expected_weeks = [13, 14].map{|index| Aef::Week.new(2011, index)}

      described_class.parse_week_range(semester, '13 + 14 ').should == expected_weeks
    end

    it "should be able to parse '12-25'" do
      expected_weeks = (12..25).map{|index| Aef::Week.new(2011, index)}

      described_class.parse_week_range(@semester, '12-25').should == expected_weeks
    end

    it "should be able to parse ' 12 - 25'" do
      expected_weeks = (12..25).map{|index| Aef::Week.new(2011, index)}

      described_class.parse_week_range(@semester, ' 12 - 25').should == expected_weeks
    end

    it "should be able to parse '12,14,15,17'" do
      semester = Semester.make(:start_week => '2011-W10', :end_week => '2011-W24')

      expected_weeks = [12, 14, 15, 17].map{|index| Aef::Week.new(2011, index)}

      described_class.parse_week_range(semester, '12,14,15,17').should == expected_weeks
    end

    it "should be able to parse '12, 14,15 , 17'" do
      semester = Semester.make(:start_week => '2011-W10', :end_week => '2011-W24')
      
      expected_weeks = [12, 14, 15, 17].map{|index| Aef::Week.new(2011, index)}

      described_class.parse_week_range(semester, '12, 14,15 , 17').should == expected_weeks
    end

    it "should be able to parse '49-51,1+3'" do
      semester = Semester.make(:start_week => '2011-W44', :end_week => '2012-W06')

      expected_weeks = []
      expected_weeks += [49, 50, 51].map{|index| Aef::Week.new(2011, index)}
      expected_weeks += [1, 3].map{|index| Aef::Week.new(2012, index)}

      described_class.parse_week_range(semester, '49-51,1+3').should == expected_weeks
    end

    it "should be able to parse 'ab KW 15'" do
      semester = Semester.make(:start_week => '2011-W12', :end_week => '2011-W25')

      expected_weeks = (15..25).map{|index| Aef::Week.new(2011, index)}

      described_class.parse_week_range(semester, 'ab KW 15').should == expected_weeks
    end

    it "should be able to parse '16'" do
      expected_weeks = [Aef::Week.new(2011, 16)]

      described_class.parse_week_range(@semester, '16').should == expected_weeks
    end

    it "should be able to parse '13,9,21'" do
      expected_weeks = [13, 9, 21].map{|index| Aef::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '13,9,21').should == expected_weeks
    end

    it "should be able to parse '14,15,17,18'" do
      expected_weeks = [14, 15, 17, 18].map{|index| Aef::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '14,15,17,18').should == expected_weeks
    end

    it "should be able to parse '12,13,15,17,19,21,23'" do
      expected_weeks = [12, 13, 15, 17, 19, 21, 23].map{|index| Aef::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '12,13,15,17,19,21,23').should == expected_weeks
    end

    it "should be able to parse '13-18'" do
      expected_weeks = (13..18).map{|index| Aef::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '13-18').should == expected_weeks
    end

    it "should be able to parse '20-25'" do
      expected_weeks = (20..25).map{|index| Aef::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '20-25').should == expected_weeks
    end

    it "should be able to parse '12-24'" do
      expected_weeks = (12..24).map{|index| Aef::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '12-24').should == expected_weeks
    end

    it "should be able to parse '13-25'" do
      expected_weeks = (13..25).map{|index| Aef::Week.new(2011, index) }

      described_class.parse_week_range(@semester, '13-25').should == expected_weeks
    end
  end
end
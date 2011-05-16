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
  MENU_TREE = Nokogiri.parse(MENU_FILE.read)
  PLAN_TREE = Nokogiri.parse(PLAN_FILE.read)

  before(:each) do
    study_unit_page = Object.new
    study_unit_page.stub(:search) {|*args| PLAN_TREE.search(*args) }
    menu_page_form = {}
    menu_page_form.stub(:submit) { study_unit_page }
    menu_page = Object.new
    menu_page.stub(:forms) { [menu_page_form] }
    menu_page.stub(:search) {|*args| MENU_TREE.search(*args) }
    agent = Object.new
    agent.stub(:get) { menu_page }
    
    @scraper = described_class.new(
      :agent  => agent,
      :logger => Logger.new(nil)
    )
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

  context "#scrape_people" do
    it "should contain all people" do
      @scraper.scrape_people.map(&:eva_id).to_set.should == Set.new([
        'Ajwani',
        'Al Naqib',
        'Alda',
        'Asteroth',
        'Bergmann',
        'Berrendorf',
        'Bienert',
        'Bilek',
        'Bonne',
        'Borutzky',
        'Breuer',
        'Buck-Emden',
        'Böhmer',
        'Bürsner',
        'Caspari-Prokop',
        'Chamberlain',
        'Chung',
        'Cornely',
        'Elders-Boll',
        'Ewert',
        'Freund',
        'Goletz',
        'Grebe',
        'Grosskreutz',
        'Göddertz',
        'Hartmann',
        'Heiden',
        'Hense',
        'Herpers',
        'Hinkenjann',
        'Horstmann',
        'Jung',
        'Kahl',
        'Kaiser',
        'Kannen',
        'Kaul',
        'Kees',
        'Kless',
        'Klewitz-H.',
        'Klinkner',
        'Kraetzschmar',
        'Kroll',
        'Kronberger',
        'Kühlwetter',
        'Leischner',
        'Lemke-Rust',
        'Lindlar',
        'Löbbermann',
        'Mertens',
        'Müller',
        'Neunast',
        'Noelle',
        'Oestreich',
        'Osh',
        'Pannen',
        'Pauly',
        'Pein',
        'Ploeger',
        'Pohl',
        'Prassler',
        'Prokop',
        'Reinert',
        'SASEROS',
        'Sakal',
        'Schaible',
        'Schneider',
        'Schreiber',
        'Schön',
        'Sezer',
        'Siebigteroth',
        'Stuhm',
        'Thiele',
        'Tornau',
        'Uhde',
        'Ullmann',
        'Vieten',
        'Vollmer',
        'Wagner',
        'Waldstein',
        'Wamser',
        'Weil',
        'Weinand',
        'Wirtgen,J.',
        'Witt',
        'Wolf',
        'Wunderlich',
        'Zacharias',
        'von Schenck',
        'von_der_Hude'
      ])
    end
  end

  context "#scrape_semester" do
    it "should persist the correct semester" do
      semester = @scraper.scrape_semester
      semester.should be_persisted
      semester.start_year.should == 2011
      semester.season.should == :summer
    end

    it "should correctly set the week range" do
      semester = @scraper.scrape_semester
      semester.should be_persisted
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

  context "#scrape_courses" do
    it "should correctly scrape Netzmanagement I" do
      study_unit = StudyUnit.make!(:eva_id => 'BCS4')

      raw_events_by_course = @scraper.scrape_courses(study_unit)

      raw_events_by_course[Course.find_by_name('Netzmanagement I')].to_set.should == Set.new([
        {
          :start_time => '8:15',
          :end_time   => '9:45',
          :period     => '21.03.2011-20.06.2011 (KW 12-25)',
          :room       => 'C115',
          :lecturers  => 'Leischner',
          :categories => 'V'
        }
      ])
    end

    it "should correctly scrape Software Engineering II" do
      study_unit = StudyUnit.make!(:eva_id => 'BCS4')

      raw_events_by_course = @scraper.scrape_courses(study_unit)

      raw_events_by_course[Course.find_by_name('Software Engineering II')].to_set.should == Set.new([
        {
          :start_time => '14:00',
          :end_time   => '15:30',
          :period     => '24.03.2011-23.06.2011 (KW 12-25)',
          :room       => 'A048 Audimax (H1/H2)',
          :lecturers  => 'Bürsner, Tornau',
          :categories => 'V',
        },
        {
          :start_time => '8:15',
          :end_time   => '9:45',
          :period     => '24.03.2011-23.06.2011 (KW 12-25)',
          :room       => 'C181',
          :lecturers  => 'Bürsner, Tornau',
          :categories => 'Ü',
          :groups     => '1'
        },
        {
          :start_time => '10:00',
          :end_time   => '11:30',
          :period     => '24.03.2011-23.06.2011 (KW 12-25)',
          :room       => 'C181',
          :lecturers  => 'Bürsner, Tornau',
          :categories => 'Ü',
          :groups     => '2'
        },
        {
          :start_time => '11:45',
          :end_time   => '13:15',
          :period     => '24.03.2011-23.06.2011 (KW 12-25)',
          :room       => 'C181',
          :lecturers  => 'Bürsner, Tornau',
          :categories => 'Ü',
          :groups     => '3'
        },
        {
          :start_time => '15:45',
          :end_time   => '17:15',
          :period     => '24.03.2011-23.06.2011 (KW 12-25)',
          :room       => 'C181',
          :lecturers  => 'Bürsner, Tornau',
          :categories => 'Ü',
          :groups     => '4'
        },
        {
          :start_time => '17:30',
          :end_time   => '19:00',
          :period     => '24.03.2011-23.06.2011 (KW 12-25)',
          :room       => 'C181',
          :lecturers  => 'Bürsner, Tornau',
          :categories => 'Ü',
          :groups     => '5'
        },
        {
          :start_time => '17:45',
          :end_time   => '19:15',
          :period     => '21.03.2011-20.06.2011 (KW 12-25)',
          :room       => 'C181',
          :lecturers  => 'Bürsner, Tornau',
          :categories => 'Ü',
          :groups     => '6'
        },
        {
          :start_time => '16:00',
          :end_time   => '17:30',
          :period     => '21.03.2011-20.06.2011 (KW 12-25)',
          :room       => 'C181',
          :lecturers  => 'Bürsner, Tornau',
          :categories => 'Ü',
          :groups     => '7'
        }
      ])
    end
  end

  context "#scrape_event" do
    it "should build an event from raw data" do
      course   = Course.make!
      schedule = course.study_unit.semester.schedules.create!

      raw_data = {
          :start_time => '16:00',
          :end_time   => '17:30',
          :period     => '21.03.2011-20.06.2011 (KW 12-25)',
          :room       => 'C181',
      }

      event = @scraper.scrape_event(course, schedule, raw_data)

      event.should be_persisted
      event.first_start.should == Time.new(2011, 3, 21, 16)
      event.first_end.should == Time.new(2011, 3, 21, 17, 30)
      event.until.should == Date.new(2011, 6, 20)
      event.room.should == 'C181'
    end

    it "should add extracted recurrence to the raw data" do
      course   = Course.make!
      schedule = course.study_unit.semester.schedules.create!

      raw_data = {
        :start_time => '16:00',
        :end_time   => '17:30',
        :period     => '21.03.2011-20.06.2011 (KW 12-25)',
        :room       => 'C181',
      }

      lambda {
        @scraper.scrape_event(course, schedule, raw_data)
      }.should change{ raw_data[:recurrence] }.from(nil).to('KW 12-25')
    end
  end

  context "#scrape_groups" do
    it "should be able to scrape '3'" do
      result = @scraper.scrape_groups('3')

      result.map(&:name).to_set.should == %w{3}.to_set
    end

    it "should be able to scrape ' 3 '" do
      result = @scraper.scrape_groups(' 3 ')

      result.map(&:name).to_set.should == %w{3}.to_set
    end

    it "should be able to scrape '3+TZ'" do
      result = @scraper.scrape_groups('3+TZ')

      result.map(&:name).to_set.should == %w{3 TZ}.to_set
    end

    it "should be able to scrape '1-3+TZ'" do
      result = @scraper.scrape_groups('1-3+TZ')

      result.map(&:name).to_set.should == %w{1 2 3 TZ}.to_set
    end

    it "should be able to scrape '4-7'" do
      result = @scraper.scrape_groups('4-7')

      result.map(&:name).to_set.should == %w{4 5 6 7}.to_set
    end

    it "should be able to scrape '3+4'" do
      result = @scraper.scrape_groups('3+4')

      result.map(&:name).to_set.should == %w{3 4}.to_set
    end
  end

  context "#scrape_categories" do
    it "should be able to scrape 'V'" do
      result = @scraper.scrape_categories('V')

      result.map(&:eva_id).to_set.should == %w{V}.to_set
    end

    it "should be able to scrape 'Ü'" do
      result = @scraper.scrape_categories('Ü')

      result.map(&:eva_id).to_set.should == %w{Ü}.to_set
    end

    it "should be able to scrape 'VÜP'" do
      result = @scraper.scrape_categories('VÜP')

      result.map(&:eva_id).to_set.should == %w{V Ü P}.to_set
    end

    it "should be able to scrape 'Ü/P'" do
      result = @scraper.scrape_categories('Ü/P')

      result.map(&:eva_id).to_set.should == %w{Ü P}.to_set
    end

    it "should not scrape 'Projekt'" do
      result = @scraper.scrape_categories('Projekt')

      result.map(&:eva_id).to_set.should == [].to_set
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
      pending("Disabled because parser won't handle this. Fix this in upstream data source.")
      
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
      pending("Disabled because parser won't handle this. Fix this in upstream data source.")
      
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
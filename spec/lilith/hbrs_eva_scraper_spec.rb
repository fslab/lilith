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

    @scraper.scrape_study_units.should have(16).items
  end
end
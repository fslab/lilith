# encoding: UTF-8

require 'uri'
require 'mechanize'

class Lilith::HbrsEvaScraper
  SEMESTER_LABEL_PATTERN = /^(.*) (\d+)$/

  attr_accessor :agent

  def initialize(options = {})
    @agent = options[:agent] || Mechanize.new
    @url   = URI.parse(options[:url] || 'https://eva2.inf.h-brs.de/stundenplan/')
  end

  def call
    #TODO: Dynamically find the correct values
    @semester = Semester.find_or_create_by_begin_year_and_season(
      Date.parse('2011-01-01'),
      :summer
    )

    scrape_study_units
  end

  def scrape_study_units
    study_units = []

    @agent.get(@url) do |page|
      page.search("select[@name = 'identifier_semester']/option").each do |option|
        next if option['value'].blank?

        study_unit = @semester.study_units.find_or_initialize_by_eva_id(option['value'])
        
        SEMESTER_LABEL_PATTERN =~ option.inner_html

        study_unit.program = $1
        study_unit.position = $2
        study_unit.save!

        study_units << study_unit
      end
    end

    study_units
  end
end
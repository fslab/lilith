# encoding: UTF-8

require 'set'
require 'uri'

require 'mechanize'

class Lilith::HbrsEvaScraper
  SEMESTER_LABEL_PATTERN  = /^(.*) (\d+)$/
  NAME_PATTERN            = /(.*) \((.*)\)$/
  NAME_WITH_GROUP_PATTERN = /(.*) \((.*)\)$/
  PERIOD_PATTERN = /(\d{2}\.\d{2}\.\d+)-(\d{2}\.\d{2}\.\d+) \((.*)\)/
  CATEGORY_TABLE = {
    'V' => 'Vorlesung',
    'Ü' => 'Übung',
    'P' => 'Praktikum'
  }

  attr_accessor :agent, :semester

  def initialize(options = {})
    @agent = options[:agent] || Mechanize.new
    @url   = URI.parse(options[:url] || 'https://eva2.inf.h-brs.de/stundenplan/')
    #TODO: Dynamically find the correct values
    @semester = options[:semester] || Semester.find_or_create_by_begin_year_and_season(
      Date.parse('2011-01-01'),
      :summer
    )
  end

  def call
    scrape_tutors
  
    scrape_study_units.each do |study_unit|
      scrape_courses(study_unit.plans.create)
    end

    true
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
  
  def scrape_tutors
    tutors = []

    @agent.get(@url) do |page|
      page.search("select[@name = 'identifier_dozent']/option").each do |option|
        next if option['value'].blank?

        tutors << Tutor.find_or_create_by_eva_id(option.inner_html)
      end
    end

    tutors
  end

  def scrape_courses(plan)
    courses = []

    agent.get(@url) do |page|
      form = page.forms.first
      form['weeks'] = '12;13;14;15;16;17;18;19;20;21;22;23;24;25'
      form['days']  = '1-7'
      form['mode']  = 'table'
      form['identifier_semester'] = plan.study_unit.eva_id
      form['show_semester'] = 'Display timetable'
      form.submit.search('table/tr').each do |row|
        next if row.search("td[@class = 'header']").size > 0

        raw_weekday    = row.search("td[@class = 'liste-wochentag']").inner_html
        raw_start_time = row.search("td[@class = 'liste-startzeit']").inner_html
        raw_end_time   = row.search("td[@class = 'liste-endzeit']").inner_html
        raw_period     = row.search("td[@class = 'liste-beginn']").inner_html
        raw_room       = row.search("td[@class = 'liste-raum']").inner_html
        raw_name       = row.search("td[@class = 'liste-veranstaltung']").inner_html
        raw_tutors     = row.search("td[@class = 'liste-wer']").inner_html

        if NAME_WITH_GROUP_PATTERN =~ raw_name
          name = $1
          raw_groups = $2
          raw_categories = $3
        else
          NAME_PATTERN =~ raw_name
          name = $1
          raw_categories = $2
        end

        course = plan.courses.find_or_create_by_name(name)
        courses << course
        event = course.events.new

        event.room = raw_room

        PERIOD_PATTERN =~ raw_period

        event.first_start = DateTime.parse("#{$1} #{raw_start_time}")
        event.first_end   = DateTime.parse("#{$1} #{raw_end_time}")

        last_date        = Date.parse($2)
        event.recurrence = $3

        event.save!

        #scrape_group_associations(event, raw_groups) if raw_groups
        #scrape_tutor_associations(event, raw_tutors)
        #scrape_category_associations(event, raw_categories)
      end
    end

    courses
  end

=begin
  def scrape_group_associations(event, raw_groups)
    group_associations = Set.new

    raw_groups.split(/,/).each do |range|
      range.split(/\+/).each do |summand|
        if summand.include?('-')
          min, max = summand.split(/\-/)

          (min..max).each do |group_symbol|
            group_associations << event.group_associations.find_or_create(
              :group => event.course.groups.find_or_create_by_name(group_symbol)
            )
          end
        else
          group_associations << event.group_associations.find_or_create(
            :group => event.course.group.find_or_create_by_name(summand)
          )
        end
      end
    end

    group_associations
  end

  def scrape_tutor_associations(event, raw_tutors)
    tutor_associations = Set.new

    raw_tutors.split(/,/).each do |tutor|
      tutors << event.tutor_associations.find_or_create(
        :tutor => Tutor.find_or_create_by_eva_id(person.strip)
      )
    end

    tutor_associations
  end

  def scrape_category_associations(raw_categories)
    category_associations = Set.new

    raw_categories.gsub(/, /, '').chars.each do |symbol|
      category_associations << event.category_associations.find_or_create(
        :category => Category.find_or_create_by_eva_id(symbol.upcase)
      )
    end

    category_associations
  end
=end
end

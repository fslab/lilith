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

require 'set'
require 'uri'

require 'mechanize'

class Lilith::HbrsEvaScraper
  SEMESTER_LABEL_PATTERN  = /^(.*) (\d+)$/
  NAME_PATTERN            = /(.*) Gr(?:\.(.*)| ?([\dA-Z].*)) \((.*)\)$|(.*) \((.*)\)$/
  PERIOD_PATTERN = /(\d{2}\.\d{2}\.\d+)-(\d{2}\.\d{2}\.\d+) \((.*)\)/
  CATEGORY_TABLE = {
    'V' => 'Vorlesung',
    'Ü' => 'Übung',
    'P' => 'Praktikum',
    'S' => 'Seminar'
  }

  attr_accessor :agent, :url, :semester, :logger

  def initialize(options = {})
    @agent = options[:agent] || Mechanize.new
    @url   = URI.parse(options[:url] || 'https://eva2.inf.h-brs.de/stundenplan/')
    #TODO: Dynamically find the correct values
    @semester = options[:semester] || Semester.find_or_create_by_start_year_and_season(
      2011,
      :summer
    )
    @logger = options[:logger] || Rails.logger
  end

  def call
    scrape_tutors.each do |tutor|
      logger.debug "Scraped Tutor: #{tutor}"
    end

    scrape_study_units.each do |study_unit|
      logger.debug "Scraped StudyUnit: #{study_unit}"
      scrape_courses(study_unit)
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

        study_unit.position = $2

        program_name = $1
        program_name.gsub!(/^B /, 'Bachelor ')
        program_name.gsub!(/^M /, 'Master ')

        study_unit.program = program_name

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

  def scrape_courses(study_unit)
    courses = []

    plan = study_unit.plans.create!

    agent.get(@url) do |page|
      form = page.forms.first
      form['weeks'] = '12;13;14;15;16;17;18;19;20;21;22;23;24;25'
      form['days']  = '1-7'
      form['mode']  = 'table'
      form['identifier_semester'] = study_unit.eva_id
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

        NAME_PATTERN =~ raw_name

        if $5 and $6
          name = $5
          raw_categories = $6
        else
          name = $1
          raw_groups = $2 || $3
          raw_categories = $4
        end

        # Remove leading and trailing spaces and remove double spaces
        name.strip!
        name.gsub!(/  +/, ' ')

        course = study_unit.courses.find_or_create_by_name(name)
        courses << course
        event = plan.events.new

        event.course = course
        event.room = raw_room

        PERIOD_PATTERN =~ raw_period

        event.first_start = DateTime.parse("#{$1} #{raw_start_time}")
        event.first_end   = DateTime.parse("#{$1} #{raw_end_time}")
        event.until       = Date.parse($2)
        event.recurrence  = $3

        event.save!

        scrape_group_associations(event, raw_groups) if raw_groups
        #scrape_tutor_associations(event, raw_tutors)
        scrape_category_associations(event, raw_categories)
      end
    end

    courses
  end

  def scrape_group_associations(event, raw_groups)
    group_associations = Set.new

    raw_groups.split(/,/).each do |range|
      range.split(/\+/).each do |summand|
        if summand.include?('-')
          min, max = summand.split(/\-/)

          (min..max).each do |group_symbol|
            group_associations << event.group_associations.find_or_create_by_group_id(
              event.course.groups.find_or_create_by_name(group_symbol.strip)
            )
          end
        else
          group_associations << event.group_associations.find_or_create_by_group_id(
            event.course.groups.find_or_create_by_name(summand.strip)
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

  def scrape_category_associations(event, raw_categories)
    category_associations = Set.new

    raw_categories.gsub(/, /, '').chars.each do |symbol|
      category_associations << event.category_associations.find_or_create_by_category_id(
        Category.find_or_create_by_eva_id(symbol.upcase)
      )
    end

    category_associations
  end

end

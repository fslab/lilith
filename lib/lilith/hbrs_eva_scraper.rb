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

require 'set'
require 'uri'

require 'mechanize'

class Lilith::HbrsEvaScraper
  class TimeSyncError < StandardError; end
  
  SEMESTER_LABEL_PATTERN  = /^(.*) (\d+)$/
  NAME_PATTERN            = /(.*) Gr(?:\.(.*)| ?([\dA-Z].*)) \((.*)\)$|(.*) \((.*)\)$/
  PERIOD_PATTERN          = /(\d{2}\.\d{2}\.\d+)-(\d{2}\.\d{2}\.\d+) \((.*)\)/

  # Parse a range into a sequence of tokens
  def self.parse_range(range)
    tokens = []

    range.split(/[,;+]/).each do |sub_range|
      if sub_range.include?('-')
        min, max = sub_range.split(/\-/)

        tokens << (min.strip..max.strip)
      else
        tokens << sub_range.strip
      end
    end

    tokens
  end

  # Parses a week range string and returns a sequence of Week objects
  def self.parse_week_range(semester, week_range)
    if /ab KW (\d+)/ =~ week_range
      include = false

      semester.weeks.select do |week|
        include = true if week.index == $1.to_i
        include
      end
    elsif not week_range.blank?
      # Parse the week_range into a sequence of Integers
      week_numbers = []

      parse_range(week_range).each do |token|
        if token.is_a?(Range)
          week_numbers += (token.min.to_i..token.max.to_i).to_a
        else
          week_numbers << token.to_i
        end
      end

      # Select all weeks which are addressed by week_numbers
      semester.weeks.select {|week| week_numbers.include?(week.index) }.sort
    else
      semester.weeks.to_a
    end
  end

  attr_accessor :agent, :url, :semester, :logger

  def initialize(options = {})
    if options[:agent]
      @agent = options[:agent]
    else
      @agent = Mechanize.new
      original, library = */(.*) \(.*\)$/.match(@agent.user_agent)
      @agent.user_agent = "Lilith/#{Lilith::VERSION} #{library} (https://www.fslab.de/redmine/projects/lilith/)"
    end

    @url   = URI.parse(options[:url] || 'https://eva2.inf.h-brs.de/stundenplan/')
    @logger = options[:logger] || Rails.logger
  end

  def call
    ActiveRecord::Base.transaction do
      semester = scrape_semester

      scrape_tutors.each do |tutor|
        logger.debug "Scraped Tutor: #{tutor.inspect}"
      end

      schedule = semester.schedules.create!

      scrape_study_units(semester).each do |study_unit|
        logger.debug "Scraped StudyUnit: #{study_unit.inspect}"
        scrape_courses(study_unit, schedule)
      end
    end
    
    true
  end

  # Detect the current semester and persist it in database if not already there.
  def scrape_semester
    logger.debug "Scraping semester"
    semester = nil

    logger.debug "Fetching menu page"
    
    @agent.get(@url) do |page|
      week_numbers_raw = page.search("select[@name = 'weeks']/option").first['value']
      week_numbers     = week_numbers_raw.split(';')

      semester_raw = nil

      logger.debug "Fetching first study unit page"

      # Fetch the first study unit available and scrape the semester out of it
      page.search("select[@name = 'identifier_semester']/option").each do |option|
        unless option['value'].blank?
          form = page.forms.first
          form['weeks'] = week_numbers_raw
          form['days']  = '1-7'
          form['mode']  = 'table'
          form['identifier_semester'] = option['value']
          form['show_semester'] = 'Display timetable'
          semester_raw = form.submit.search("//b[text() = 'Semester:']/following::text()[1]").text
          break
        end
      end

      original, season_raw, year_raw = */(Sommer|Winter)semester (\d+)/.match(semester_raw)

      case season_raw
      when 'Sommer'
        season = :summer
      when 'Winter'
        season = :winter
      end

      year = year_raw.to_i

      logger.debug "Found semester (Season: #{season}, Year: #{year})"

      logger.debug "Finding or creating semester"

      # Find or create the semester in database
      semester = Semester.find_or_create_by_start_year_and_season(
        year, season
      )

      # Detect the semester's week range and update the persisted object
      start_week = Lilith::Week.new(year.to_i, week_numbers.first.to_i)
      week_range = start_week.until_index(week_numbers.last.to_i)
      end_week   = week_range.max

      logger.debug "Updating week range (Start: #{start_week}, End: #{end_week})"

      semester.start_week = start_week.to_s
      semester.end_week   = end_week.to_s
      semester.save!

      logger.debug "Scraping semester finished"
    end
    
    semester
  end

  def scrape_study_units(semester)
    study_units = []

    @agent.get(@url) do |page|
      page.search("select[@name = 'identifier_semester']/option").each do |option|
        next if option['value'].blank?

        study_unit = semester.study_units.find_or_initialize_by_eva_id(option['value'])

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

  def scrape_courses(study_unit, schedule)
    courses = []

    agent.get(@url) do |page|
      # If time differs more than 5 minutes between document source and here, abort
      local_time  = Time.now
      remote_time = Time.parse(page.search("div[@class = 'eva-footer']/text()").last.to_s)

      if (local_time - remote_time).abs > 5.minutes
        raise TimeSyncError, "Scraping aborted. Local time: #{local_time}; Remote time: #{remote_time}"
      end
      logger.debug "Local time: #{local_time}"
      logger.debug "Remote time: #{remote_time}"

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
        event = schedule.events.new

        event.course = course
        event.room = raw_room

        original, start_date, end_date, raw_recurrence = *PERIOD_PATTERN.match(raw_period)

        event.first_start = Time.parse("#{start_date} #{raw_start_time}")
        event.first_end   = Time.parse("#{start_date} #{raw_end_time}")
        event.until       = Date.parse(end_date)
        event.save!

        scrape_week_associations(event, raw_recurrence)
        scrape_group_associations(event, raw_groups) if raw_groups
        scrape_tutor_associations(event, raw_tutors)
        scrape_category_associations(event, raw_categories)
      end
    end

    courses
  rescue Exception => exception
    raise handle_exception(exception)
  end

  # Parses a raw recurrence string and sets week associations and recurrence
  # attribute for the given event
  #
  # TODO: Carries no state, should become class method
  def scrape_week_associations(event, raw_recurrence)
    original, recurrence, week_range = */((?:u|g)?KW)(?: (.*))?/.match(raw_recurrence)

    filtered_weeks = self.class.parse_week_range(event.course.study_unit.semester, week_range)

    if recurrence == 'uKW' or recurrence == 'gKW'
      event.recurrence = recurrence
      
      filtered_weeks = filtered_weeks.select(&:odd?) if recurrence == 'uKW'
      filtered_weeks = filtered_weeks.select(&:even?) if recurrence == 'gKW'
    end

    event.save!

    filtered_weeks.each do |week|
      event.week_associations.create!(
        :week_id => ::Week.find_or_create_by_year_and_index(week.year, week.index)
      )
    end
  end

  # Parses a raw groups string and sets group associations for the given event
  #
  # TODO: Carries no state, should become class method
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

  # Parses a raw tutors string and sets tutor associations for the given event
  #
  # TODO: Carries no state, should become class method
  def scrape_tutor_associations(event, raw_tutors)
    tutor_associations = Set.new

    logger.debug "Scraping Tutor associations from '#{raw_tutors}' for event #{event.inspect}"

    raw_tutors.split(/,/).each do |tutor|
      tutor = Tutor.find_or_create_by_eva_id(tutor.strip)

      logger.debug "Tutor object for eva_id '#{tutor}' is #{tutor.inspect}"

      tutor_association = event.tutor_associations.find_or_create_by_tutor_id(tutor)

      logger.debug "EventTutorAssociation created: #{tutor_association.inspect}"

      tutor_associations << tutor_association
    end

    tutor_associations
  end

  # Parses a raw categories string and sets category associations for the
  # given event
  #
  # TODO: Carries no state, should become class method
  def scrape_category_associations(event, raw_categories)
    category_associations = Set.new

    unless raw_categories == 'Projekt'
      raw_categories.gsub(/[\/,]/, '').chars.each do |symbol|
        category_associations << event.category_associations.find_or_create_by_category_id(
          Category.find_or_create_by_eva_id(symbol.strip.upcase)
        )
      end
    end

    category_associations
  end

  protected

  # Relays the given exception to the configured logger
  def handle_exception(exception)
    logger.error <<-EOS
      #{exception.class} occured
      #{exception.message}
      #{exception.backtrace}
    EOS

    exception
  end
end
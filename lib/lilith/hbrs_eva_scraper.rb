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

# This class encapsulates the whole event data acquisition from the public
# interface of Eva² of Hoschschule Bonn-Rhein-Sieg
#
# TODO: Most of the instance methods do not use object state to be easier to
# test. Maybe it would be a good idea to refactor them into class methods
class Lilith::HbrsEvaScraper
  # Errors specific to Lilith::HbrsEvaScraper
  class Error < StandardError; end
  
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
          range = (token.min.to_i..token.max.to_i).to_a
          raise Error 'Empty week range, possible parsing error' if range.empty?
          week_numbers += range
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
    @agent = options[:agent]
    @url   = URI.parse(options[:url] || 'https://eva2.inf.h-brs.de/stundenplan/')
    @logger = options[:logger] || Rails.logger
  end

  def agent
    @agent || Lilith.default_agent
  end

  def call
    ActiveRecord::Base.transaction do
      # If time differs more than 5 minutes between document source and here, abort
      local_time  = Time.now
      remote_time = Time.parse(menu_page.search("div[@class = 'eva-footer']/text()").last.to_s)

      if (local_time - remote_time).abs > 5.minutes
        raise Error, "Timing difference. Local time: #{local_time}; Remote time: #{remote_time}"
      end
      logger.debug "Local time: #{local_time}"
      logger.debug "Remote time: #{remote_time}"

      # Start scraping
      semester = scrape_semester

      scrape_people.each do |person|
        logger.debug "Scraped Person: #{person.inspect}"
      end

      schedule_state = semester.schedule_states.create!

      scrape_study_units(semester).each do |study_unit|
        logger.debug "Scraped StudyUnit: #{study_unit.inspect}"

        scrape_courses(study_unit).each do |course, raw_events|

          raw_events.each do |raw_event|

            event = scrape_event(course, schedule_state, raw_event)

            if raw_event[:groups]
              scrape_groups(course, raw_event[:groups]).each do |group|
                event.group_associations.find_or_create_by_group_id(group)
              end
            end

            scrape_categories(raw_event[:categories]).each do |category|
              event.category_associations.find_or_create_by_category_id(category)
            end

            scrape_week_associations(event, raw_event[:recurrence])
            scrape_lecturer_associations(event, raw_event[:lecturers])

            # TODO: Put Event duplicate detection and merging here
          end
        end
      end
    end
    
    true
  rescue Exception => exception
    logger.error <<-EOS
      #{exception.class} occured
      #{exception.message}
      #{exception.backtrace}
    EOS

    raise exception
  end

  # Fetches and caches the menu page
  def menu_page
    if @menu_page
      logger.debug "Fetching menu page (cached)"
      @menu_page
    else
      logger.debug "Fetching menu page"
      @menu_page = agent.get(@url)
    end
  end

  # Fetches and caches all week numbers for the current semester
  def week_numbers
    if @week_numbers
      logger.debug "Fetching week numbers (cached)"
      @week_numbers
    else
      logger.debug "Fetching week numbers"
      @week_numbers = menu_page.search("select[@name = 'weeks']/option").first['value'].sub(/54/, '2').sub(/55/, '3').sub(/56/, '4').split(/;/)

      raise Error, 'No week numbers found' if @week_numbers.empty?
    end

    @week_numbers
  end

  # Fetches and caches all study unit ids for the current semester
  def study_units
    if @study_units
      logger.debug "Fetching study unit ids (cached)"
      @study_units
    else
      logger.debug "Fetching study unit ids"

      @study_units = {}

      menu_page.search("select[@name = 'identifier_semester']/option").each do |option|
        next if option['value'].blank?

        @study_units[option.text] = option['value']
      end

      raise Error, 'No study units found' if @study_units.empty?
    end

    @study_units
  end

  # Fetches and caches the page of a specific study unit
  def study_unit_page(study_unit_id)
    @study_unit_page ||= {}

    if @study_unit_page[study_unit_id]
      logger.debug "Fetching study unit page for '#{study_unit_id}' (cached)"
    else
      logger.debug "Fetching study unit page for '#{study_unit_id}'"

      form = menu_page.forms.first
      form['weeks'] = week_numbers.join(';')
      form['days']  = '1-7'
      form['mode']  = 'table'
      form['identifier_semester'] = study_unit_id
      form['show_semester'] = 'Display timetable'

      @study_unit_page[study_unit_id] = form.submit
    end

    @study_unit_page[study_unit_id]
  end

  # Detect the current semester and persist it in database if not already there.
  def scrape_semester
    logger.debug "Scraping semester"
    logger.debug "Fetching study unit pages until semester can be scraped"

    match_result = nil
    study_unit_id = nil

    study_units.each do |label, study_unit_id|
      page = study_unit_page(study_unit_id)
      break if match_result = /(Sommer|Winter)semester (\d+)/.match(
        page.search("//b[text() = 'Semester:']/following::text()[1]").text
      )
    end

    if match_result
      logger.debug "Scrapable semester found on page of study unit '#{study_unit_id}'"
    else
      raise Error, 'No Semester information found on any study unit page'
    end

    # Normalize raw data for database usage
    original, season_raw, year_raw = *match_result

    case season_raw
    when 'Sommer'
      season = :summer
    when 'Winter'
      season = :winter
    end

    year = year_raw.to_i

    logger.debug "Found semester (Season: #{season}, Year: #{year})"

    # Find or create the semester in database
    semester = Semester.find_or_create_by_start_year_and_season(year, season)

    # Detect the semester's week range and update the persisted object
    start_week = Aef::Week.new(year.to_i, week_numbers.first.to_i)
    week_range = start_week.until_index(week_numbers.last.to_i)
    end_week   = week_range.max

    logger.debug "Updating week range (Start: #{start_week}, End: #{end_week})"

    semester.start_week = start_week.to_s
    semester.end_week   = end_week.to_s
    semester.save!

    logger.debug "Scraping semester finished"

    semester
  end

  # Scrapes all study units
  def scrape_study_units(semester)
    scraped_study_units = []

    study_units.each do |label, id|
      study_unit = semester.study_units.find_or_initialize_by_eva_id(id)

      original, program_name, study_unit.position = */^(.*) (\d+)$/.match(label)

      program_name.gsub!(/^B /, 'Bachelor ')
      program_name.gsub!(/^M /, 'Master ')

      study_unit.program = program_name

      study_unit.save!

      scraped_study_units << study_unit
    end

    scraped_study_units
  end

  # Scrapes all people by eva id
  def scrape_people
    scraped_people = []

    menu_page.search("select[@name = 'identifier_dozent']/option").each do |option|
      next if option['value'].blank?

      scraped_people << Person.find_or_create_by_eva_id(option.inner_html)
    end

    scraped_people
  end

  # Scrapes all courses for a given study unit
  #
  # Returns a hash with course objects as keys and arrays of raw event data as values
  def scrape_courses(study_unit)
    scraped_courses = {}

    logger.debug study_unit.inspect 
    logger.debug study_unit_page(study_unit.eva_id).inspect

    study_unit_page(study_unit.eva_id).search('tr').each do |row|
      next if row.search("td[@class = 'header']").size > 0

      raw_data = {
        :start_time => row.search("td[@class = 'liste-startzeit']").inner_html,
        :end_time   => row.search("td[@class = 'liste-endzeit']").inner_html,
        :period     => row.search("td[@class = 'liste-beginn']").inner_html,
        :room       => row.search("td[@class = 'liste-raum']").inner_html,
        :lecturers  => row.search("td[@class = 'liste-wer']").inner_html
      }

      /(.*) Gr(?:\.(.*)| ?([\dA-Z].*)) \((.*)\)$|(.*) \((.*)\)$/ =~ row.search("td[@class = 'liste-veranstaltung']").inner_html

      if $5 and $6
        name = $5
        raw_data[:categories] = $6
      else
        name = $1
        raw_data[:groups] = $2 || $3
        raw_data[:categories] = $4
      end

      # Remove leading and trailing spaces and remove double spaces
      name.strip!
      name.gsub!(/  +/, ' ')

      course = study_unit.courses.find_or_create_by_name(name)

      scraped_courses[course] ||= []

      if scraped_courses[course].empty?
        logger.debug "New course found: #{course.name} (#{course.id})"
      else
        logger.debug "Course update found: #{course.name} (#{course.id})"
      end

      logger.debug "Adding raw data: #{raw_data}"
      
      scraped_courses[course] << raw_data
    end

    scraped_courses
  end

  # Parses raw data values and builds an event object belonging to course and schedule state
  #
  # Attention: raw_data gets modified!
  def scrape_event(course, schedule_state, raw_data)
    unless raw_data.keys.to_set.superset?([:start_time, :end_time, :period, :room].to_set)
      raise ArgumentError, 'Raw data values do not match requirements' + " #{raw_data.inspect}"
    end

    event = schedule_state.events.new
    event.course = course
    event.room   = raw_data[:room]

    match_result = /(\d{2}\.\d{2}\.\d+)-(\d{2}\.\d{2}\.\d+) \((.*)\)/.match(raw_data[:period])
    original, start_date, end_date, raw_data[:recurrence] = *match_result

    event.first_start = Time.parse("#{start_date} #{raw_data[:start_time]}")
    event.first_end   = Time.parse("#{start_date} #{raw_data[:end_time]}")
    event.until       = Date.parse(end_date)
    event.save!

    event
  end

  # Parses a raw groups string and finds or creates contained groups and
  # returns them as an Array
  def scrape_groups(course, raw_groups)
    group_names = []

    self.class.parse_range(raw_groups).map do |token|
      if token.is_a?(Range)
        range = (token.min..token.max).to_a
        raise Error 'Empty group range, possible parsing error' if range.empty?
        group_names += range
      else
        group_names << token
      end
    end

    group_names.map do |group_name|
      Group.find_or_create_by_name_and_course_id(group_name, course)
    end
  end

  # Parses a raw categories string and finds or creates contained categories
  # and returns them as an Array
  def scrape_categories(raw_categories)
    if raw_categories == 'Projekt'
      []
    else
      raw_categories.gsub(/[\/,]/, '').chars.map do |category_symbol|
        Category.find_or_create_by_eva_id(category_symbol.strip.upcase)
      end
    end
  end

  # Parses a raw recurrence string and sets week associations and recurrence
  # attribute for the given event
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


  # Parses a raw lecturers string and sets lecturer associations for the given event
  def scrape_lecturer_associations(event, raw_lecturers)
    lecturer_associations = Set.new

    logger.debug "Scraping Person associations from '#{raw_lecturers}' for event #{event.inspect}"

    raw_lecturers.split(/, /).each do |lecturer|
      lecturer = Person.find_or_create_by_eva_id(lecturer.strip)

      logger.debug "Person object for eva_id '#{lecturer}' is #{lecturer.inspect}"

      lecturer_association = event.lecturer_associations.find_or_create_by_lecturer_id(lecturer)

      logger.debug "EventLecturerAssociation created: #{lecturer_association.inspect}"

      lecturer_associations << lecturer_association
    end

    lecturer_associations
  end

end
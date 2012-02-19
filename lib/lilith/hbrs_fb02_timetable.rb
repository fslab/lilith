# encoding: utf-8

class Lilith::HbrsFb02Timetable

  attr_accessor :agent, :url, :logger

  def initialize(options = {})
    @agent  = options[:agent]
    @url    = URI.parse(options[:url] || 'https://www.inf.h-brs.de/Fachbereichszeitplan.html')
    @logger = options[:logger] || Rails.logger
  end

  def agent
    @agent || Lilith.default_agent
  end

  def call
    # scraped timetable page and creates event objects for all listed events in table body
    timetable_page.search(".//*[@id='inhaltBreit']/table/tr").each do |event|
      date, description = ''

      # timetable consists of the date in the fist column and the description of this event in the second
      event.search('./td[1]').map do |point|
        date = point.text
      end

      event.search('./td[2]').map do |item|
        description = item.text
      end

      # normalized given data from site and creates objects in database
      create_event_objects(date, description)
    end

    # if every thing is fine
    true
  end

  def timetable_page
    # cache timetable page
    @timetable_page = agent.get(@url)
  end

  def create_event_objects(date, description)
    # This function is a very crappy shit of code and should be replaced in further versions of this scraper!
    # TODO: Replace this silly if/unless calls and array accesses with real and less error-prone decisions.

    puts "Original data:  #{date} #{description}"

    dates = date.scan(/(\d{2})\.(\d{2})\.(\d{4})|(\d{2})\.(\d{2})\.|(\d{2})\./)
    times = date.scan(/(\d{1,2}\:\d{1,2})\s[uU]/)

    dates[0] = dates[0].compact
    dates[1] = dates[1].compact unless dates[1].nil?

    if dates[0].size == 1 and not dates[1].nil?
      start_date = "#{dates[0][0]}.#{dates[1][1]}.#{dates[1][2]}"
    elsif dates[0].size == 2 and not dates[1].nil?
      start_date = "#{dates[0][0]}.#{dates[0][1]}.#{dates[1][2]}"
    else
      start_date = dates[0].compact.join('.')
    end


    unless dates[1].nil?
      end_date = dates[1].compact.join('.')
    else
      end_date = start_date
    end


    start_time = times[0]

    unless times[1].nil? or times[1] == ''
      end_time = times[1]
    else
      end_time = '23:59'
    end

    # TODO: create real event objects
    puts "Start: " + Time.parse("#{start_date} #{start_time}").to_s
    puts "End: " + Time.parse("#{end_date} #{end_time}").to_s

    puts "Description: #{description.chomp}"

    puts
  end
end
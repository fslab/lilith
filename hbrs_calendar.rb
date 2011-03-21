# encoding: UTF-8
require 'rubygems'
require 'mechanize'
require 'icalendar'
require 'date'
require 'pathname'

agent = Mechanize.new
calendar = Icalendar::Calendar.new

OUTPUT_FOLDER = Pathname('output')
OUTPUT_FOLDER.mkdir unless OUTPUT_FOLDER.exist?
OUTPUT_FILE = OUTPUT_FOLDER + 'hbrs_calendar.ical'
NAME_PATTERN   = /(.*) \((.*)\)$/
PERIOD_PATTERN = /(\d{2}\.\d{2}\.\d+)-(\d{2}\.\d{2}\.\d+) \((.*)\)/
RECURRENCE_PATTERN = /((?:u|g)KW) (.*)/
CATEGORY_TABLE = {
  'V' => 'Vorlesung',
  'Ü' => 'Übung',
  'P' => 'Praktikum'
}

agent.get('https://eva2.inf.h-brs.de/stundenplan/') do |page|
  form = page.forms.first
  form['weeks'] = '12;13;14;15;16;17;18;19;20;21;22;23;24;25'
  form['days']  = '1-7'
  form['mode']  = 'table'
  form['identifier_semester'] = 'BCS4'
  form['show_semester'] = 'Display timetable'
  form.submit.search('table/tr').each do |row|
    next if row.search("td[@class = 'header']").size > 0

    event = Icalendar::Event.new

    raw_weekday    = row.search("td[@class = 'liste-wochentag']").inner_html
    raw_start_time = row.search("td[@class = 'liste-startzeit']").inner_html
    raw_end_time   = row.search("td[@class = 'liste-endzeit']").inner_html
    raw_period     = row.search("td[@class = 'liste-beginn']").inner_html
    raw_room       = row.search("td[@class = 'liste-raum']").inner_html
    raw_name       = row.search("td[@class = 'liste-veranstaltung']").inner_html
    raw_people     = row.search("td[@class = 'liste-wer']").inner_html

    NAME_PATTERN   =~ raw_name
    
    name = $1
    category_marker = $2

    next unless name =~ /Computergrafik|Hypermedia|Software Engineering II|Betriebssysteme|Embedded C\+\+ und VHDL|Unternehmensgründung/ # Set courses here

    if name =~ /Gr\.\d/
      next unless name =~ /Gr\.4/ # Set group number here
    end
    
    puts name

    categories = []

    CATEGORY_TABLE.each do |marker, name| 
      if category_marker.include?(marker)
        categories << name
      end
    end

    event.categories = categories
    PERIOD_PATTERN =~ raw_period
    
    start_datetime = DateTime.parse("#{$1} #{raw_start_time}")
    end_datetime   = DateTime.parse("#{$1} #{raw_end_time}")
    last_date      = Date.parse($2)
    recurrence_marker = $3

    event.dtstart    = start_datetime
    event.dtend      = end_datetime
    event.summary    = name
    event.description = <<-DESC
Typ: #{categories.join(', ')}
Veranstalter: #{raw_people}
    DESC
    event.tzid       = "/freeassociation.sourceforge.net/Tzfile/Europe/Berlin"
    event.location   = "Hochschule Bonn-Rhein-Sieg, Raum: #{raw_room}"

    RECURRENCE_PATTERN =~ recurrence_marker

    case $1
    when 'uKW', 'gKW'
      event.recurrence_rules ["FREQ=WEEKLY;INTERVAL=2;UNTIL=#{last_date.strftime('%Y%m%d')}"]
    else
      event.recurrence_rules ["FREQ=WEEKLY;UNTIL=#{last_date.strftime('%Y%m%d')}"]
    end


    calendar.add(event)
  end
end

OUTPUT_FILE.open('w') do |io|
  io.write calendar.to_ical
end

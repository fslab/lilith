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

require 'rubygems'
require 'mechanize'

require 'lilith/human_name_parser'

class Lilith::HbrsPeopleScraper
  attr_accessor :agent
  
  def initialize (options = {})
    if options[:agent]
      @agent = options[:agent]
    else
      @agent = Mechanize.new
      original, library = */(.*) \(.*\)$/.match(@agent.user_agent)
      @agent.user_agent = "Lilith/#{Lilith::VERSION} #{library} (https://www.fslab.de/redmine/projects/lilith/)"
    end

    @urls = options[:url] || people_urls
  end

  def call
    ActiveRecord::Base.transaction do
      scrape_people
    end
  end

  def scrape_people
    all_people = Person.all
    modified_people = []
    
    @urls.each do |page|

      page = @agent.get(page)
      page.search("//div[@id = 'inhalt']/p/*").each do |link|
        next if link.text == '« Zurück' or
                link.text == 'E-Mail' or
                /^E-Mail/ =~ link.text or
                /^Öffnungszeiten/ =~ link.text or
                /^Raum/ =~ link.text or
                /^writeEmail/ =~ link.text

        parser = Lilith::HumanNameParser.new(link.text)
        person_info = parser.parse

        if person_info[:surname]

          if link['href']
            if link['href'].include? "http\:\/\/"
              person_info[:website] = link['href']
            elsif link['href'].include? "\.html"
              person_info[:website] = "http://www.inf.h-bonn-rhein-sieg.de" + link['href']
            end
          end

          matches = {}

          remaining_people = all_people.dup

          while person = remaining_people.pop
            string_comparator = Amatch::Sellers.new(person_info[:surname])
            matches[string_comparator.match(person.eva_id)] = person
          end

          if exact_match = matches[0.0]
            exact_match.title       = person_info[:title]
            exact_match.forename    = person_info[:forename]
            exact_match.middlename  = person_info[:middlename]
            exact_match.surname     = person_info[:surname]
            exact_match.profile_url = person_info[:website]
            exact_match.save!
            modified_people << exact_match
          else
            puts "Surname: #{person_info[:surname]}"
            matches.sort.each do |score, person|
              puts "  #{score} - #{person.eva_id}"
            end
          end
        end
      end
    end
    modified_people
  end
  
  def people_urls
    links = Array.new

    page = @agent.get("http://www.inf.fh-bonn-rhein-sieg.de/personen.html")
    
    page.search("//*[@id='inhaltBreit']/p[2]/a").each do |link|
      links << "https://www.inf.h-bonn-rhein-sieg.de" + link['href']
    end
    
    links
  end
end

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

# This class encapsulates the people data aquisition from the public website of
# Hochschule Bonn-Rhein-Sieg
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

    @urls.each do |page|

      page = @agent.get(page)
      page.search("//div[@id = 'inhalt']/p/*[1]").each do |first_paragraph_subnode|
        if %w{strong a}.include?(first_paragraph_subnode.name)
          label = first_paragraph_subnode.search('.//text()').text
          url   = first_paragraph_subnode.attr('href') || first_paragraph_subnode.search('.//a').first.try(:attr, 'href')

          next if label == '« Zurück' or
                  label == 'E-Mail' or
                  /^E-Mail/ =~ label or
                  /^Öffnungszeiten/ =~ label or
                  /^Raum/ =~ label or
                  /^writeEmail/ =~ label

          person_info = Lilith::HumanNameParser.new(label).parse

          if person_info[:surname]

            if url
              if url.include? "http\:\/\/"
                person_info[:website] = url
              elsif url.include? "\.html"
                person_info[:website] = "http://www.inf.h-bonn-rhein-sieg.de" + url
              end
            end


            if mapping = PeopleScraperMapping.find_by_surname(person_info[:surname])
              unless mapping.reject?
                person = Person.find_or_create_by_eva_id(mapping.eva_id)
              end
            else
              unless person = Person.find_by_eva_id(person_info[:surname])
                person = Person.new
              end
            end

            if person
              person.title = person_info[:title]
              person.forename = person_info[:forname]
              person.middlename = person_info[:middlename]
              person.surname = person_info[:surname]
              person.profile_url = person_info[:website]
              person.save!
            end

          end

          puts "Surname: #{person_info[:surname]}"
          puts "Forename: #{person_info[:forename]}"
          puts "URL: #{person_info[:website]}"
          puts

        end
      end
    end
    true
  end
  
  def people_urls
    links = []
    page = @agent.get("http://www.inf.fh-bonn-rhein-sieg.de/personen.html")

    page.search("//*[@id='inhaltBreit']/p[2]/a").each do |link|
      if link['href'].include? "http\:\/\/"
        links << link['href']
      else
        links << "http://inf.h-brs.de" + link['href']
      end
    end

    links
  end
end

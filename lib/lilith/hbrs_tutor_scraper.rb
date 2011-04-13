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

class Lilith::HbrsTutorScraper
  attr_accessor :agent
  
  def initialize (options = {})
    @agent = options[:agent] || Mechanize.new
    @urls = options[:url] || tutor_urls
  end

  def call
    scrape_tutors
  end

  def scrape_tutors
    all_tutors = Tutor.all
    modified_tutors = []
    
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
        tutor_info = parser.parse

        if tutor_info[:surname]

          if link['href']
            if link['href'].include? "http\:\/\/"
              tutor_info[:website] = link['href']
            elsif link['href'].include? "\.html"
              tutor_info[:website] = "http://www.inf.h-bonn-rhein-sieg.de" + link['href']
            end
          end

          matches = {}

          remaining_tutors = all_tutors.dup

          while tutor = remaining_tutors.pop
            string_comparator = Amatch::Sellers.new(tutor_info[:surname])
            matches[string_comparator.match(tutor.eva_id)] = tutor
          end

          if exact_match = matches[0.0]
            exact_match.title       = tutor_info[:title]
            exact_match.forename    = tutor_info[:forename]
            exact_match.middlename  = tutor_info[:middlename]
            exact_match.surname     = tutor_info[:surname]
            exact_match.profile_url = tutor_info[:website]
            exact_match.save!
            modified_tutors << exact_match
          else
            puts "Surname: #{tutor_info[:surname]}"
            matches.sort.each do |score, tutor|
              puts "  #{score} - #{tutor.eva_id}"
            end
          end
        end
      end
    end
    modified_tutors
  end
  
  def tutor_urls
    links = Array.new

    page = @agent.get("http://www.inf.fh-bonn-rhein-sieg.de/personen.html")
    
    page.search("//*[@id='inhaltBreit']/p[2]/a").each do |link|
      links << "https://www.inf.h-bonn-rhein-sieg.de" + link['href']
    end
    
    links
  end
end

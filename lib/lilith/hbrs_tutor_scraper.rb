# encoding: UTF-8

require 'rubygems'
require 'mechanize'
require 'pp'

class Lilith::HbrsTutorScraper
  SECTION_LINK_PATTERN = "//p/a[@href and not(@href='javascript:history.back()')]"

  attr_accessor :agent
  
  def initialize (options = {})
    @agent = options[:agent] || Mechanize.new
    @url = options[:url] || "https://www.inf.h-bonn-rhein-sieg.de/Personen/ProfessorInnen.html"
  end

  def call
    scrape_tutors
  end

  def scrape_tutors
    page = @agent.get(@url)
    page.parser.xpath(SECTION_LINK_PATTERN).each do |link|

      puts split_up_title(link.text)
      
      if link['href'].include? "http\:\/\/"
        puts link['href']
     else
       if link['href'].include? "\.html"
         puts "http://www.inf.h-bonn-rhein-sieg.de" + link['href']
         # puts link.text.scan(/Prof\.|Dr\.\-Ing|Dr\./)
       end
     end

      
    end
  end

  def split_up_title (title_and_name)
    title_and_name.split(' ').each do |feld|
      if feld.eql?("Prof.")|feld.eql?("Dr.")|feld.eql?("Dr.-Ing.")
        if !title.empty?
          title = title + " "
        end
      end
      title = title + feld
    end
    title
  end
end
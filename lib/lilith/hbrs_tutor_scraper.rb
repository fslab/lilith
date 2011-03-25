# encoding: UTF-8

require 'rubygems'
require 'mechanize'

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
    #TODO: RÜckgabewerte an Objekt binden und in Datenbank schreiben
    page = @agent.get(@url)
    page.parser.xpath(SECTION_LINK_PATTERN).each do |link|

      tutor.title = split_up_title(link.text)
      tutor.forename = split_up_forename(link.text)
      tutor.surname = split_up_surname(link.text)
      
      if link['href'].include? "http\:\/\/"
        tutor.website = link['href']
      else
       if link['href'].include? "\.html"
         tutor.website = "http://www.inf.h-bonn-rhein-sieg.de" + link['href']
       end
     end
     tutor.save!
   end
  end

  #Titel
  def split_up_title (title_and_name)
    title = ""
    title_and_name.split(' ').each do |feld|
      if feld.eql?("Prof.")|feld.eql?("Dr.")|feld.eql?("Dr.-Ing.")
        if title.empty?
          title = feld
        else
          title = title + " " + feld
        end
      end
    end
    title
  end

  #Vorname
  def split_up_forename (title_and_name)
    #TODO: Zweite Vornamen und Adelsnamen werden nicht beachtet
    array = split_up_title(title_and_name).split(' ')
    forename = title_and_name.split(' ').at(array.size)
  end

  #Nachname
  def split_up_surname (title_and_name)
    surname = title_and_name.split(' ').last
  end
end
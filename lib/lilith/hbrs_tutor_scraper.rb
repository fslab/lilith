# encoding: UTF-8
require 'rubygems'
require 'mechanize'
require 'pp'

class Lilith::HbrsTutorScraper

  attr_accessor :title
  attr_accessor :forename
  attr_accessor :surname
  attr_accessor :profil_url
  
  def initialize
    @agent = Mechanize.new
    @url = "http://www.inf.h-bonn-rhein-sieg.de/Personen/ProfessorInnen.html"
  end

  def call
    page = @agent.get(@url)
    page.parser.xpath("//p/a[@href]").each do |link|
      if link['href'].include? "http\:\/\/"
        puts link['href'] + " " + link.text
     else
       if link['href'].include? "\.html"
         puts "http://www.inf.h-bonn-rhein-sieg.de" + link['href'] + " " + link.text
       end
     end
     #@title.scan(/Prof\.|Dr\.\-Ing|Dr\./)
    end
  end
end

#!/usr/bin/ruby

#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.

require 'rubygems'
#require 'hpricot'
#require 'open-uri'
#require 'iconv'
#require 'nokogiri'
require 'mechanize'

begin	
	def food (page,id)
		tmp_list = Array.new
		page.search("//div[@id='"+ id +"']/table/tbody/tr/td").each do |object|
			tmp_list << object.content.squeeze
		end
		return tmp_list
	end
	
	def date (page)
		return page.search("//div[@id='c1840']/h1").to_s.gsub(/<\/?[^>]*>/,"")
	end

	def correct_str (str_list)
		c_str_list = Array.new
		str_list.each do |t| 
			if !(/\A(..)\z/i.match(t)) && !t.empty? then
				c_str_list << t.sub(/(\s.,.|[1-9].*|\sS$)/,"")
			end
 		end
 		return c_str_list
 	end
 	
	@agent = Mechanize.new
	page = @agent.get("http://www.studentenwerk-bonn.de/gastronomie/speiseplaene/diese-woche/")

	#------------------Ausgabe-------------------------

	meat = "c1825"
	veg  = "c1823"
	extra = "c1841"

	puts date(page) + "\nFleisch oder Fisch Hauptkomponente\n\n"
	
	correct_str(food(page,meat)).each do |final|
 	puts final
 	end

	puts "\nVegetarische Hauptkomponente\n\n"

 	correct_str(food(page,veg)).each do |final|
 	puts final
 	end
end

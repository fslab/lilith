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

module Lilith
  module_function

  # Scrapes the main data source: Eva² of Hochschule Bonn-Rhein-Sieg
  #
  # For console debug output use
  #
  #   Lilith.scrape_eva(:logger => :console)
  def scrape_eva(options = {})
    HbrsEvaScraper.new(scraper_options_helper(options)).call
  end

  # Scrapes the tutor list of Hochschule Bonn-Rhein-Sieg and merges
  # the results with the existing objects in database
  def scrape_tutors(options = {})
    HbrsTutorScraper.new(scraper_options_helper(options)).call
  end

  # Translates options for a better interface
  def scraper_options_helper(options)
    result_options = options.dup

    if options[:logger] == :console
      result_options[:logger] = Logger.new(STDOUT)
    end

    result_options
  end
end

require 'lilith/hbrs_eva_scraper'
require 'lilith/hbrs_tutor_scraper'

module Lilith
  module_function

  def scrape_eva(*args)
    HbrsEvaScraper.new(*args).call
  end

  def scrape_tutors(*args)
    HbrsTutorsScraper.new(*args).call
  end
end

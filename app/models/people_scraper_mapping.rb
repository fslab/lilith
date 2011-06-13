class PeopleScraperMapping < ActiveRecord::Base
  include Lilith::UUIDHelper


  default_scope order('surname DESC')


end
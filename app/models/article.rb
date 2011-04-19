class Article < ActiveRecord::Base
  include Lilith::UUIDHelper

  validates :name, :presence => true
  validates :body, :presence => true
    
end

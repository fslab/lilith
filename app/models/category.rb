class Category < ActiveRecord::Base
  has_many :category_event_associations, :dependent => :destroy
  has_many :events, :through => :category_event_associations
end
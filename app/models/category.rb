class Category < ActiveRecord::Base
  has_many :event_associations,
           :class_name => 'CategoryEventAssociation',
           :dependent => :destroy
  has_many :events, :through => :event_associations
end
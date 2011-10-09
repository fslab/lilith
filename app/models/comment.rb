class Comment < ActiveRecord::Base
  include Lilith::UUIDHelper

  belongs_to :course
  belongs_to :author, class_name: 'User'
end

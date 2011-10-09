class User < ActiveRecord::Base
  has_many :comments, foreign_key: :author_id
end

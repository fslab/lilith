class User::Role < ActiveRecord::Base
  include Lilith::UUIDHelper

  set_table_name 'user_roles'

  has_many :user_associations, :class_name => 'User::RoleAssociation'
  has_many :users, :through => :user_associations

  validates :name, :uniqueness => true

  # Default order
  default_scope order('name ASC')

  ADMIN = find_or_create_by_name('admin')
end
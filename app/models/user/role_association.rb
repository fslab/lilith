class User::RoleAssociation < ActiveRecord::Base
  include Lilith::UUIDHelper

  set_table_name 'user_role_associations'

  belongs_to :user
  belongs_to :role, :class_name => 'User::Role'
end
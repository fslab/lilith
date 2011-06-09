# A Lilith user
class User < ActiveRecord::Base
  include Lilith::UUIDHelper

  has_many :role_associations,
           :class_name => 'User::RoleAssociation',
           :dependent => :destroy
  has_many :roles,
           :class_name => 'User::Role',
           :through => :role_associations
  has_many :schedules,
           :dependent => :destroy
  
  validates :login, :uniqueness => true

  # Default order
  default_scope order('login ASC')

  # Let users authenticate
  acts_as_authentic do |config|
    config.validate_password_field = false
  end

  # Either finds a returning user from local database or looks up LDAP if he
  # exists. If he exists, a record is generated in the local database
  def self.find_or_create_from_ldap(login)
    user = find_by_login(login) || create_from_ldap_if_valid(login)

    user.update_attributes!(:name => user.ldap_entry.try(:display_name)) if user

    user
  end

  # Create a User record in database if he exists in LDAP
  def self.create_from_ldap_if_valid(login)
    if ldap_entry = LdapUser.find(login)
      user = create(:login => login)
      user.ldap_entry = ldap_entry
    end
  rescue ActiveLdap::EntryNotFound
    nil
  end

  # Returns the user's LDAP representation
  def ldap_entry
    @ldap_entry ||= LdapUser.find(login)
  end

  def ldap_entry=(ldap_entry)
    @ldap_entry = ldap_entry
  end

  protected

  # Authenticate a user to find out if the password is correct
  def valid_ldap_credentials?(plain_password)
    ldap_entry.bind(plain_password)
    ldap_entry.remove_connection
    true
  rescue ActiveLdap::AuthenticationError, ActiveLdap::LdapError::UnwillingToPerform
    false
  end
end
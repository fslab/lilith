# A Lilith user
class User < ActiveRecord::Base
  include Lilith::UUIDHelper

  # Let users authenticate
  acts_as_authentic do |config|
    config.validate_password_field = false
  end

  # Either finds a returning user from local database or looks up LDAP if he
  # exists. If he exists, a record is generated in the local database
  def self.find_or_create_from_ldap(login)
    find_by_login(login) || create_from_ldap_if_valid(login)
  end

  # Create a User record in database if he exists in LDAP
  def self.create_from_ldap_if_valid(login)
    create(:login => login) if LdapUser.find(login)
  rescue ActiveLdap::EntryNotFound
    nil
  end

  # Returns the user's LDAP representation
  def ldap_entry
    @ldap_entry ||= LdapUser.find(login)
  end

  # The user's full name
  def name
    ldap_entry.try(:display_name) || login
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
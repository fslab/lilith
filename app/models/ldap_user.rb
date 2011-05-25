# A users representation in LDAP
class LdapUser < ActiveLdap::Base
  ldap_mapping(
    :dn_attribute => 'uid',
    :scope => :sub,
    :prefix => 'ou=students'
  )
end
# this class will install the salt-master and salt-minion
# example for site.pp:
#   include salt
#
class salt {
  class { 'salt::params': }
  include 'salt::master'
  include 'salt::minion'
  include 'salt::api'
}

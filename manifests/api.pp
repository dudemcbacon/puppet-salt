# this class will only install the salt api
# example:
# class { 'salt::api': }
#
class salt::api (
  $api_config_manage         = $salt::params::api_config_manage,
  $api_config                = $salt::params::api_config,)
inherits salt::params {
  include 'salt::api::install'
  include 'salt::api::config'
  include 'salt::api::service'

  # Anchor this as per #8140 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'salt::api::begin': }

  anchor { 'salt::api::end': }

  Anchor['salt::api::begin'] -> Class['::salt::api::install'] -> Class['::salt::api::config'
    ] ~> Class['::salt::api::service'] -> Anchor['salt::api::end']

}

# this class will only install the salt api
# example:
# class { 'salt::api': }
#
class salt::api (
  $api_config_manage    = $::salt::params::api_config_manage,
  $api_config_template  = $::salt::params::api_config_template,
  $api_enable_cherrypy  = $::salt::params::api_enable_cherrypy,
  $api_enable_tornado   = $::salt::params::api_enable_tornado,
  $api_enable_wsgi      = $::salt::params::api_enable_wsgi,
  $api_package_ensure   = $::salt::params::api_package_ensure,
  $api_package_name     = $::salt::params::api_package_name,
  $api_service_name     = $::salt::params::api_service_name,
  $api_service_ensure   = $::salt::params::api_service_ensure,
  $api_service_manage   = $::salt::params::api_service_manage,
  $api_service_enable   = $::salt::params::api_service_enable,
  $master_config        = $::salt::params::master_config,
  $master_config_manage = $::salt::params::master_config_manage,
) inherits salt::params {

  include 'salt::api::install'
  include 'salt::api::config'
  include 'salt::api::service'


  # Anchor this as per #8140 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'salt::api::begin': }

  anchor { 'salt::api::end': }

  Anchor['salt::api::begin']
    -> Class['::salt::api::install']
      -> Class['::salt::api::config']
        ~> Class['::salt::api::service']
          -> Anchor['salt::api::end']

}

# this class is used to configure the salt api config file
class salt::api::config (
  $api_config_manage    = $salt::api::api_config_manage,
  $api_config_template  = $salt::api::api_config_template,
  $api_enable_cherrypy  = $salt::api::api_enable_cherrypy,
  $api_enable_tornado   = $salt::api::api_enable_tornado,
  $api_enable_wsgi      = $salt::api::api_enable_wsgi,
  $master_config        = $salt::api::master_config,
  $master_config_manage = $salt::api::master_config_manage,
) inherits salt::api {
  # installs the api config file defined in salt::params
  concat::fragment { 'api':
    target  => $master_config,
    content => template($api_config_template),
    order   => '02'
  }

  concat { '/etc/salt/master':
    ensure  => present,
    owner   => 0,
    group   => 0,
    mode    => '0664',
    replace => $master_config_manage,
  }
}

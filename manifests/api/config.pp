# this class is used to configure the salt api config file
class salt::api::config (
  $api_config_manage         = $salt::api::api_config_manage,
  $api_config                = $salt::api::api_config,)
inherits salt::api {
  # installs the api config file defined in salt::params
  file { $api_config:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0664',
    content => template($api_template),
    replace => $api_config_manage,
  }

  # todo template the yaml parts in config file
}

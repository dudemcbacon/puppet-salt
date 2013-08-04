class salt::master::install (
  $master_package_ensure = $salt::master::master_package_ensure,
  $master_package_name   = $salt::master::master_package_name,) inherits
salt::master {
  @package { ["salt", "$master_package_name",]: ensure => present, }

  if $::osfamily == 'Archlinux' {
    realize Package['salt']
  } else {
    realize Package["$master_package_name"]
  }

}


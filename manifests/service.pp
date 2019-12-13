# == Class: stash::service
#
# This manages the stash service. See README.md for details
#
class stash::service  (

  Boolean $service_manage = $stash::service_manage,
  String $service_ensure  = $stash::service_ensure,
  Boolean $service_enable = $stash::service_enable,
  $service_file_location  = $stash::params::service_file_location,
  $service_file_template  = $stash::params::service_file_template,
  $service_lockfile       = $stash::params::service_lockfile,

) inherits stash::params {

  file { $service_file_location:
    content => template($service_file_template),
    mode    => '0755',
  }

  if $stash::service_manage {
    if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '7' {
      exec { 'refresh_systemd':
        command     => '/bin/systemctl daemon-reload',
        refreshonly => true,
        subscribe   => File[$service_file_location],
        before      => Service['stash'],
      }
    }

    service { 'stash':
      ensure  => $service_ensure,
      enable  => $service_enable,
      require => File[$service_file_location],
    }
  }
}

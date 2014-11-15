# == Class: stash::service
#
# This manages the stash service. See README.md for details
# 
class stash::service (

  $service_manage = $stash::service_manage,
  $service_ensure = $stash::service_ensure,
  $service_enable = $stash::service_enable,

) {

  validate_bool($service_manage)

  if $stash::service_manage {
    validate_string($service_ensure)
    validate_bool($service_enable)
    service { 'stash':
      ensure  => $service_ensure,
      enable  => $service_enable,
      start   => '/etc/init.d/stash start',
      restart => '/etc/init.d/stash restart',
      stop    => '/etc/init.d/stash stop',
      status  => '/etc/init.d/stash status',
      require => Class['stash::config'],
    }
  }
}

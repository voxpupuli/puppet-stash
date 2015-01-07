# == Class: stash::service
#
# This manages the stash service. See README.md for details
# 
class stash::service  (

  $service_manage = $stash::service_manage,
  $service_ensure = $stash::service_ensure,
  $service_enable = $stash::service_enable,

) inherits stash::params {

  validate_bool($service_manage)

  file { $service_file_location:
    content => template($service_file_template),
    mode    => '0755',
  }


  if $stash::service_manage {
    validate_string($service_ensure)
    validate_bool($service_enable)
    service { 'stash':
      ensure  => $service_ensure,
      enable  => $service_enable,
      require => File[$service_file_location],
    }
  }
}

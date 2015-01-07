# == Class: stash::params
#
# Defines default values for stash module
#
class stash::params {
  case "${::osfamily}${::operatingsystemmajrelease}" {
    /RedHat7/: {
      $json_packages           = 'rubygem-json'
      $service_file_location   = '/usr/lib/systemd/system/stash.service'
      $service_file_template   = 'stash/stash.service.erb'
      $service_lockfile        = '/var/lock/subsys/stash'
    } /Debian/: {
      $json_packages           = [ 'rubygem-json', 'ruby-json' ]
      $service_file_location   = '/etc/init.d/stash'
      $service_file_template   = 'stash/stash.initscript.debian.erb'
      $service_lockfile        = '/var/lock/stash'
    } /RedHat6/: {
      $json_packages           = [ 'rubygem-json', 'ruby-json' ]
      $service_file_location   = '/etc/init.d/stash'
      $service_file_template   = 'stash/stash.initscript.redhat.erb'
      $service_lockfile        = '/var/lock/subsys/stash'
    } default: {
   
    }
  }
}

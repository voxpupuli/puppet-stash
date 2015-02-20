# == Class: stash::params
#
# Defines default values for stash module
#
class stash::params {
  case $::osfamily {
    /RedHat/: {
      if $::operatingsystemmajrelease == '7' {
        $json_packages           = 'rubygem-json'
        $service_file_location   = '/usr/lib/systemd/system/stash.service'
        $service_file_template   = 'stash/stash.service.erb'
        $service_lockfile        = '/var/lock/subsys/stash'
      } elsif $::operatingsystemmajrelease == '6' {
        $json_packages           = [ 'rubygem-json', 'ruby-json' ]
        $service_file_location   = '/etc/init.d/stash'
        $service_file_template   = 'stash/stash.initscript.redhat.erb'
        $service_lockfile        = '/var/lock/subsys/stash'
      } else {
        fail("${::operatingsystem} ${::operatingsystemmajrelease} not supported")
      }
    } /Debian/: {
      $json_packages           = [ 'rubygem-json', 'ruby-json' ]
      $service_file_location   = '/etc/init.d/stash'
      $service_file_template   = 'stash/stash.initscript.debian.erb'
      $service_lockfile        = '/var/lock/stash'
    } default: {
      fail("${::operatingsystem} ${::operatingsystemmajrelease} not supported")
    }
  }
}

# == Class: stash::params
#
# Defines default values for stash module
#
class stash::params {
  case $facts['os']['family'] {
    /RedHat/: {
      if $facts['os']['release']['major'] == '7' {
        $service_file_location   = '/usr/lib/systemd/system/stash.service'
        $service_file_template   = 'stash/stash.service.epp'
        $service_lockfile        = '/var/lock/subsys/stash'
      } elsif $facts['os']['release']['major'] == '6' {
        $json_packages           = ['rubygem-json', 'ruby-json']
        $service_file_location   = '/etc/init.d/stash'
        $service_file_template   = 'stash/stash.initscript.redhat.epp'
        $service_lockfile        = '/var/lock/subsys/stash'
      } else {
        fail("${facts['os']['name']} ${facts['os']['release']['major']} not supported")
      }
    }
    /Debian/: {
      if $facts['os']['release']['full'] == '18.04' {
        $service_file_location   = '/etc/systemd/system/stash.service'
        $service_file_template   = 'stash/stash.service.epp'
        $service_lockfile        = '/var/lock/subsys/stash'
      } else {
        $service_file_location   = '/etc/init.d/stash'
        $service_file_template   = 'stash/stash.initscript.debian.epp'
        $service_lockfile        = '/var/lock/stash'
      }
    } default: {
      fail("${facts['os']['name']} ${facts['os']['release']['major']} not supported")
    }
  }
}

# == Class: stash::service
#
# This manages the stash service. See README.md for details
# 
class stash::service {
  if $stash::manage_service {
      service { 'stash':
      ensure  => 'running',
      enable  => true,
      start   => '/etc/init.d/stash start',
      restart => '/etc/init.d/stash restart',
      stop    => '/etc/init.d/stash stop',
      status  => '/etc/init.d/stash status',
      require => Class['stash::config'],
    }
  }
}

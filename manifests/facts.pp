# == Class: stash::facts
#
# Class to add some facts for stash. They have been added as an external fact
# because we do not want to distrubute these facts to all systems.
#
# === Parameters
#
# [*port*]
#   port that stash listens on.
# [*uri*]
#   ip that stash is listening on, defaults to localhost.
#
# === Examples
#
# class { 'stash::facts': }
#
class stash::facts (
  $ensure        = 'present',
  $port          = '7990',
  $uri           = '127.0.0.1',
  $ruby_bin      = '/opt/puppetlabs/puppet/bin/ruby',
  $context_path  = $stash::context_path,
  $json_packages = $stash::params::json_packages,
) inherits stash {

  if ! defined(File['/etc/facter']) {
    file { '/etc/facter':
      ensure  => directory,
    }
  }
  if ! defined(File['/etc/facter/facts.d']) {
    file { '/etc/facter/facts.d':
      ensure  => directory,
    }
  }

  file { '/etc/facter/facts.d/stash_facts.rb':
    ensure  => $ensure,
    content => template('stash/facts.rb.erb'),
    mode    => '0500',
  }
}

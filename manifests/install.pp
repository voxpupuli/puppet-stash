# == Class: stash::install
#
# Full description of class stash here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { stash:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class stash::install {

  require stash

  group { $stash::user: ensure => present, gid => $stash::gid } ->
  user { $stash::user:
    comment          => 'Stash daemon account',
    shell            => '/bin/true',
    home             => $stash::homedir,
    password         => '*',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
    uid              => $stash::uid,
    gid              => $stash::gid,
  } ->

  deploy::file { "atlassian-${stash::product}-${stash::version}.${stash::format}":
    target          => $stash::webappdir,
    url             => $stash::downloadURL,
    strip           => true,
    notify          => Exec["chown_${stash::webappdir}"],
    owner           => $stash::user,
    group           => $stash::group,
    download_timout => 1800,

  } ->

  file { $stash::homedir:
    ensure  => 'directory',
    owner   => $stash::user,
    group   => $stash::group,
  } ->

  exec { "chown_${stash::webappdir}":
    command     => "/bin/chown -R ${stash::user}:${stash::group} ${stash::webappdir}",
    refreshonly => true,
    subscribe   => User[$stash::user]
  } ->

  file { '/etc/init.d/stash':
    content => template('stash/stash.initscript.erb'),
    mode    => '0755',
  }

}

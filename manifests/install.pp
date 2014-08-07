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
class stash::install(
  $version     = $stash::version,
  $product     = $stash::product,
  $format      = $stash::format,
  $installdir  = $stash::installdir,
  $homedir     = $stash::homedir,
  $user        = $stash::user,
  $group       = $stash::group,
  $uid         = $stash::uid,
  $gid         = $stash::gid,
  $git_version = $stash::git_version,

  $downloadURL = $stash::downloadURL,
  $webappdir
  ) {

  if ! defined(Package['git']) {
    package { 'git':
      ensure => $git_version,
    }
  }

  group { $group:
    ensure => present,
    gid    => $gid
  } ->
  user { $user:
    comment          => 'Stash daemon account',
    shell            => '/bin/bash',
    home             => $homedir,
    password         => '*',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
    uid              => $uid,
    gid              => $gid,
  } ->

  deploy::file { "atlassian-${product}-${version}.${format}":
    target          => $webappdir,
    url             => $downloadURL,
    strip           => true,
    notify          => Exec["chown_${webappdir}"],
    owner           => $user,
    group           => $group,
    download_timout => 1800,

  } ->

  file { $homedir:
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
  } ->

  exec { "chown_${webappdir}":
    command     => "/bin/chown -R ${user}:${group} ${webappdir}",
    refreshonly => true,
    subscribe   => User[$stash::user]
  } ->

  file { '/etc/init.d/stash':
    content => template('stash/stash.initscript.erb'),
    mode    => '0755',
  }

}

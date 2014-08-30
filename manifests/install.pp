# == Class: stash::install
#
# This installs the stash module. See README.md for details
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

  case $::osfamily {
    'redhat': {
      $initscript_template = 'stash/stash.initscript.redhat.erb'
    }
    'debian': {
      $initscript_template = 'stash/stash.initscript.debian.erb'
    }
    default: {
      fail("Class['stash::install']: Unsupported osfamily: ${::osfamily}")
    }
  }

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
  }

  if ! defined(File[$installdir]) {
    file { $installdir:
      ensure => 'directory',
      owner  => $user,
      group  => $group,
    }
  }

  deploy::file { "atlassian-${product}-${version}.${format}":
    target          => $webappdir,
    url             => $downloadURL,
    strip           => true,
    notify          => Exec["chown_${webappdir}"],
    owner           => $user,
    group           => $group,
    download_timout => 1800,
    require         => [ File[$installdir], User[$user] ]
  } ->

  file { $homedir:
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  } ->

  exec { "chown_${webappdir}":
    command     => "/bin/chown -R ${user}:${group} ${webappdir}",
    refreshonly => true,
    subscribe   => User[$stash::user]
  } ->

  file { '/etc/init.d/stash':
    content => template($initscript_template),
    mode    => '0755',
  }

}

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
  $repoforge   = $stash::repoforge,
  $downloadURL = $stash::downloadURL,
  $s_or_d      = $stash::staging_or_deploy,

  $webappdir
  ) {

  case $::osfamily {
    'redhat': {
      $initscript_template = 'stash/stash.initscript.redhat.erb'
      validate_bool($repoforge)
      # If repoforge is not enabled by default, enable it
      # but only allow git to be installed from it.
      if ! defined(Class['repoforge']) and $repoforge {
        class { 'repoforge':
          enabled     => [ 'extras', ],
          includepkgs => {
            'extras' => 'git,perl-Git'
          },
          before      => Package['git']
        } ~>
        exec { "${stash::product}_clean_yum_metadata":
          command     => '/usr/bin/yum clean metadata',
          refreshonly => true
        } ~>
        # Git may already have been installed, so lets update it to a 
        # supported version.
        exec { "${stash::product}_upgrade_git":
          command     => '/usr/bin/yum -y upgrade git',
          onlyif      => '/bin/rpm -qa git',
          refreshonly => true,
        }
      }
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

  # Deploy files using either staging or deploy modules.
  $file = "atlassian-${product}-${version}.${format}"
  case $s_or_d {
    'staging': {
      require staging
      if ! defined(File[$webappdir]) {
        file { $webappdir:
          ensure => 'directory',
          owner  => $user,
          group  => $group,
        }
      }
      staging::file { $file:
        source  => "${downloadURL}/${file}",
        timeout => 1800,
      } ->
      staging::extract { $file:
        target  => $webappdir,
        creates => "${webappdir}/conf",
        strip   => 1,
        user    => $user,
        group   => $group,
        notify  => Exec["chown_${webappdir}"],
        before  => File[$homedir],
        require => [
          File[$installdir],
          User[$user],
          File[$webappdir] ],
      }
    }
    'deploy': {
      deploy::file { "atlassian-${product}-${version}.${format}":
        target          => $webappdir,
        url             => $downloadURL,
        strip           => true,
        owner           => $user,
        group           => $group,
        download_timout => 1800,
        notify          => Exec["chown_${webappdir}"],
        before          => File[$homedir],
        require         => [ File[$installdir], User[$user] ]
      }
    }
    default: {
      fail('staging_or_deploy parameter must equal "staging" or "deploy"')
    }
  }

  file { $homedir:
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    require => User[$user],
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

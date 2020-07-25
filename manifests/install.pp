# == Class: stash::install
#
# This installs the stash module. See README.md for details
#
class stash::install (
  $webappdir      = $stash::webappdir,
  $version        = $stash::version,
  $product        = $stash::product,
  $format         = $stash::format,
  $installdir     = $stash::installdir,
  $homedir        = $stash::homedir,
  $manage_usr_grp = $stash::manage_usr_grp,
  $user           = $stash::user,
  $group          = $stash::group,
  $uid            = $stash::uid,
  $gid            = $stash::gid,
  $download_url   = $stash::download_url,
  $deploy_module  = $stash::deploy_module,
  $dburl          = $stash::dburl,
  $checksum       = $stash::checksum,
) {
  include archive

  if $manage_usr_grp {
    #Manage the group in the module
    group { $group:
      ensure => present,
      gid    => $gid,
    }
    #Manage the user in the module
    user { $user:
      comment          => 'Bitbucket daemon account',
      shell            => '/bin/bash',
      home             => $homedir,
      password         => '*',
      password_min_age => '0',
      password_max_age => '99999',
      managehome       => true,
      uid              => $uid,
      gid              => $gid,
    }
  }

  $user_require = $manage_usr_grp ? {
    true  => User[$user],
    false => undef,
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

  if ! defined(File[$webappdir]) {
    file { $webappdir:
      ensure => 'directory',
      owner  => $user,
      group  => $group,
    }
  }

  case $deploy_module {
    'staging': {
      require staging
      staging::file { $file:
        source  => "${download_url}/${file}",
        timeout => 1800,
      }
      -> staging::extract { $file:
        target  => $webappdir,
        creates => "${webappdir}/bin",
        strip   => 1,
        user    => $user,
        group   => $group,
        notify  => Exec["chown_${webappdir}"],
        before  => File[$homedir],
        require => [
          File[$installdir],
          File[$webappdir],
          $user_require,
        ],
      }
    }
    'archive': {
      archive { "/tmp/${file}":
        ensure          => present,
        extract         => true,
        extract_command => 'tar xfz %s --strip-components=1',
        extract_path    => $webappdir,
        source          => "${download_url}/${file}",
        creates         => "${webappdir}/bin",
        cleanup         => true,
        checksum_verify => $stash::checksum_verify,
        checksum_type   => 'md5',
        checksum        => $checksum,
        user            => $user,
        group           => $group,
        before          => File[$homedir],
        require         => [
          File[$installdir],
          File[$webappdir],
          $user_require,
        ],
      }
    }
    default: {
      fail('deploy_module parameter must equal "archive" or staging""')
    }
  }

  file { $homedir:
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    require => $user_require,
  }

  -> exec { "chown_${webappdir}":
    command     => "/bin/chown -R ${user}:${group} ${webappdir}",
    refreshonly => true,
    subscribe   => [File[$webappdir], $user_require],
  }
}

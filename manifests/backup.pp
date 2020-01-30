
# == Class: stash::backup
#
# This installs the stash backup client
#
class stash::backup(
  $ensure               = $stash::backup_ensure,
  $schedule_hour        = $stash::backup_schedule_hour,
  $schedule_minute      = $stash::backup_schedule_minute,
  $backupuser           = $stash::backupuser,
  $backuppass           = $stash::backuppass,
  $version              = $stash::backupclient_version,
  $product              = $stash::product,
  $format               = $stash::format,
  $homedir              = $stash::homedir,
  $user                 = $stash::user,
  $group                = $stash::group,
  $deploy_module        = $stash::deploy_module,
  $download_url         = $stash::backupclient_url,
  $backup_home          = $stash::backup_home,
  $javahome             = $stash::javahome,
  $keep_age             = $stash::backup_keep_age,
  ) {

  $appdir = "${backup_home}/${product}-backup-client-${version}"

  file { $backup_home:
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  }
  file { "${backup_home}/archives":
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  }

  $file = "${product}-backup-distribution-${version}.${format}"

  file { $appdir:
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  }

  case $deploy_module {
    'staging': {
      require staging
      staging::file { $file:
        source  => "${download_url}/${version}/${file}",
        timeout => 1800,
      }
      -> staging::extract { $file:
        target  => $appdir,
        creates => "${appdir}/lib",
        strip   => 1,
        user    => $user,
        group   => $group,
        require => [
          File[$appdir],
          File[$backup_home],
        ],
      }
    }
    'archive': {
      archive { "/tmp/${file}":
        ensure          => present,
        extract         => true,
        extract_command => 'tar xfz %s --strip-components=1',
        extract_path    => $appdir,
        source          => "${download_url}/${version}/${file}",
        user            => $user,
        group           => $group,
        creates         => "${appdir}/lib",
        cleanup         => true,
        require         => [
          File[$appdir],
          File[$backup_home],
        ],
      }
    }
    default: {
      fail('deploy_module parameter must equal "archive" or staging""')
    }
  }

  if $javahome {
    $java_bin = "${javahome}/bin/java"
  } else {
    $java_bin = '/usr/bin/java'
  }

  # Enable Cronjob
  $backup_cmd = "${java_bin} -Dbitbucket.password=\"${backuppass}\" -Dbitbucket.user=\"${backupuser}\" -Dbitbucket.baseUrl=\"http://localhost:7990\" -Dbitbucket.home=${homedir} -Dbackup.home=${backup_home}/archives -jar ${appdir}/bitbucket-backup-client.jar"

  cron { 'Backup Stash':
    ensure  => $ensure,
    command => $backup_cmd,
    user    => $user,
    hour    => $schedule_hour,
    minute  => $schedule_minute,
  }

  tidy { 'remove_old_archives':
    path    => "${backup_home}/archives",
    age     => $keep_age,
    matches => '*.tar',
    type    => 'mtime',
    recurse => 2,
  }
}


# == Class: stash::backup
#
# This installs the stash backup client
#
class stash::backup(
  $ensure               = $stash::backup_ensure,
  $backupuser           = $stash::backupuser,
  $backuppass           = $stash::backuppass,
  $version              = $stash::backupclientVersion,
  $product              = $stash::product,
  $format               = $stash::format,
  $homedir              = $stash::homedir,
  $user                 = $stash::user,
  $group                = $stash::group,
  $downloadURL          = $stash::backupclientURL,
  $s_or_d               = $stash::staging_or_deploy,
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

  # Deploy files using either staging or deploy modules.
  $file = "${product}-backup-distribution-${version}.${format}"
  case $s_or_d {
    'staging': {
      require staging
      file { $appdir:
        ensure => 'directory',
        owner  => $user,
        group  => $group,
      }
      staging::file { $file:
        source  => "${downloadURL}/${version}/${file}",
        timeout => 1800,
      } ->
      staging::extract { $file:
        target  => $appdir,
        creates => "${appdir}/lib",
        strip   => 1,
        user    => $user,
        group   => $group,
        require => User[$user],
      }
    }
    'deploy': {
      #fail('only "staging" is supported for backup client')
      deploy::file { $file:
        target          => $appdir,
        url             => $downloadURL,
        strip           => true,
        owner           => $user,
        group           => $group,
        download_timout => 1800,
        #notify          => Exec["chown_${webappdir}"],
        require         => [
          File[$backup_home],
          User[$user] ]
      }
    }
    default: {
      fail('staging_or_deploy parameter must equal "staging" or "deploy"')
    }
  }

  if $javahome {
    $java_bin = "${javahome}/bin/java"
  } else {
    $java_bin = '/usr/bin/java'
  }

  # Enable Cronjob
  $backup_cmd = "${java_bin} -Dstash.password=\"${backuppass}\" -Dstash.user=\"${backupuser}\" -Dstash.baseUrl=\"http://localhost:7990\" -Dstash.home=${homedir} -Dbackup.home=${backup_home}/archives -jar ${appdir}/stash-backup-client.jar"

  cron { 'Backup Stash':
    ensure  => $ensure,
    command => $backup_cmd,
    user    => $user,
    hour    => 5,
    minute  => 0,
  }

  tidy { 'remove_old_archives': 
    path    => "${backup_home}/archives",
    age     => $keep_age,
    matches => "*.tar",
    type    => 'mtime',
    recurse => 1,
  }

}

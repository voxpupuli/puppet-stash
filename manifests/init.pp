# == Class: stash
#
# This modules installs Atlassian stash.
#
class stash(

  # JVM Settings
  $javahome     = undef,
  $jvm_xms      = '256m',
  $jvm_xmx      = '1024m',
  $jvm_permgen  = '256m',
  $jvm_optional = '-XX:-HeapDumpOnOutOfMemoryError',
  $jvm_support_recommended_args = '',
  $java_opts    = '',

  # Stash Settings
  $version      = '3.3.0',
  $product      = 'stash',
  $format       = 'tar.gz',
  $installdir   = '/opt/stash',
  $homedir      = '/home/stash',
  $user         = 'stash',
  $group        = 'stash',
  $uid          = undef,
  $gid          = undef,
  $context_path = '',

  # Database Settings
  $dbuser       = 'stash',
  $dbpassword   = 'password',
  $dburl        = 'jdbc:postgresql://localhost:5432/stash',
  $dbdriver     = 'org.postgresql.Driver',

  # Misc Settings
  $downloadURL  = 'http://www.atlassian.com/software/stash/downloads/binary/',

  # Backup Settings
  $backup_ensure       = 'present',
  $backupclientURL     = 'https://maven.atlassian.com/content/repositories/atlassian-public/com/atlassian/stash/backup/stash-backup-distribution/',
  $backupclientVersion = '1.6.0',
  $backup_home         = '/opt/stash-backup',
  $backupuser          = 'admin',
  $backuppass          = 'password',

  # Manage service
  $service_manage = true,
  $service_ensure = running,
  $service_enable = true,

  # Reverse https proxy
  $proxy = {},

  # Git version
  $git_manage  = true,
  $git_version = 'installed',

  # Enable repoforge by default for RHEL, stash requires a newer version of git
  $repoforge   = true,

  # Command to stop stash in preparation to updgrade. # This is configurable 
  # incase the stash service is managed outside of puppet. eg: using the 
  # puppetlabs-corosync module: 'crm resource stop stash && sleep 15'
  $stop_stash = 'service stash stop && sleep 15',

  # Choose whether to use nanliu-staging, or mkrakowitzer-deploy
  # Defaults to nanliu-staging as it is puppetlabs approved.
  $staging_or_deploy = 'staging',

) {

  validate_bool($git_manage)

  include stash::params

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

  $webappdir    = "${installdir}/atlassian-${product}-${version}"

  if $::stash_version {
    # If the running version of stash is less than the expected version of stash
    # Shut it down in preparation for upgrade.
    if versioncmp($version, $::stash_version) > 0 {
      notify { 'Attempting to upgrade stash': }
      exec { $stop_stash: }
      if versioncmp($version, '3.2.0') > 0 {
        exec { "rm -f ${homedir}/stash-config.properties": }
      }
    }
  }

  anchor { 'stash::start':
  } ->
  class { 'stash::install':
    webappdir => $webappdir
  } ->
  class { 'stash::config':
  } ~>
  class { 'stash::service':
  } ->
  class { 'stash::backup':
  } ->
  anchor { 'stash::end': }

}

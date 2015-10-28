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
  $version      = '3.7.0',
  $format       = 'tar.gz',
  $installdir   = '/opt/stash',
  $homedir      = '/home/stash',
  $context_path = '',
  $tomcat_port  = 7990,

  # User and Group Management Settings
  $manage_usr_grp = true,
  $user           = 'stash',
  $group          = 'stash',
  $uid            = undef,
  $gid            = undef,

  # Stash 3.8 initialization configurations
  $display_name  = 'stash',
  $base_url      = "https://${::fqdn}",
  $license       = '',
  $sysadmin_username = 'admin',
  $sysadmin_password = 'stash',
  $sysadmin_name  = 'Stash Admin',
  $sysadmin_email = '',
  $config_properties = {},

  # Database Settings
  $dbuser       = 'stash',
  $dbpassword   = 'password',
  $dburl        = 'jdbc:postgresql://localhost:5432/stash',
  $dbdriver     = 'org.postgresql.Driver',

  # Misc Settings
  $download_url  = 'http://www.atlassian.com/software/stash/downloads/binary/',
  $checksum     = undef,

  # Backup Settings
  $backup_ensure          = 'present',
  $backupclient_url       = 'https://maven.atlassian.com/public/com/atlassian/stash/backup/stash-backup-distribution',
  $backupclient_version   = '1.9.1',
  $backup_home            = '/opt/stash-backup',
  $backupuser             = 'admin',
  $backuppass             = 'password',
  $backup_schedule_hour   = '5',
  $backup_schedule_minute = '0',
  $backup_keep_age        = '4w',

  # Manage service
  $service_manage = true,
  $service_ensure = running,
  $service_enable = true,

  # Reverse https proxy
  $proxy = {},

  # Command to stop stash in preparation to updgrade. # This is configurable
  # incase the stash service is managed outside of puppet. eg: using the
  # puppetlabs-corosync module: 'crm resource stop stash && sleep 15'
  $stop_stash = 'service stash stop && sleep 15',

  # Choose whether to use puppet-staging, or puppet-archive
  $deploy_module = 'archive',

) {

  case $version {
    /[1-3]\..*/: { $product = 'stash' }
    default:     { $product = 'product' }
  }

  validate_hash($config_properties)

  include ::stash::params

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
  class { '::stash::install': webappdir => $webappdir, } ->
  class { '::stash::config': } ~>
  class { '::stash::service': } ->
  class { '::stash::backup': } ->
  anchor { 'stash::end': }

}

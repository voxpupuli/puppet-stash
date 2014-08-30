# == Class: stash
#
# This modules installs Atlassian stash.
#
class stash(

  # JVM Settings
  $javahome     = undef,
  $jvm_xms      = '256m',
  $jvm_xmx      = '1024m',
  $jvm_optional = '-XX:-HeapDumpOnOutOfMemoryError',
  $jvm_support_recommended_args = '',
  $java_opts    = '',

  # Stash Settings
  $version      = '3.2.4',
  $product      = 'stash',
  $format       = 'tar.gz',
  $installdir   = '/opt/stash',
  $homedir      = '/home/stash',
  $user         = 'stash',
  $group        = 'stash',
  $uid          = undef,
  $gid          = undef,

  # Database Settings
  $dbuser       = 'stash',
  $dbpassword   = 'password',
  $dburl        = 'jdbc:postgresql://localhost:5432/stash',
  $dbdriver     = 'org.postgresql.Driver',

  # Misc Settings
  $downloadURL  = 'http://www.atlassian.com/software/stash/downloads/binary/',

  # Manage service
  $manage_service  = true,

  # Reverse https proxy
  $proxy = {},

  # Git version
  $git_version = 'installed',

  # Enable repoforge by default for RHEL, stash requires a newer version of git
  $repoforge   = true,
) {

  $webappdir    = "${installdir}/atlassian-${product}-${version}"

  anchor { 'stash::start':
  } ->
  class { 'stash::install':
    webappdir => $webappdir
  } ->
  class { 'stash::config':
  } ~>
  class { 'stash::service':
  } ->
  anchor { 'stash::end': }

}

# == Class: stash
#
# This configures the stash module. See README.md for details
#
class stash::config(
  $version     = $stash::version,
  $user        = $stash::user,
  $group       = $stash::group,
) {

  # Atlassian changed where files are installed from ver 3.2.0
  # See issue #16 for more detail
  if versioncmp($version, '3.2.0') > 0 {
    $moved = 'shared/'
    file { "${stash::homedir}/${moved}":
      ensure  => 'directory',
      owner   => $user,
      group   => $group,
      require => File[$stash::homedir],
    }
  } else {
    $moved = undef
  }

  File {
    owner => $stash::user,
    group => $stash::group,
  }

  file { "${stash::webappdir}/bin/setenv.sh":
    content => template('stash/setenv.sh.erb'),
    mode    => '0750',
    require => Class['stash::install'],
    notify  => Class['stash::service'],
  } ->

  file { "${stash::webappdir}/bin/user.sh":
    content => template('stash/user.sh.erb'),
    mode    => '0750',
    require => [
      Class['stash::install'],
      File[$stash::webappdir],
      File[$stash::homedir]
    ],
  }->

  file { "${stash::webappdir}/conf/server.xml":
    content => template('stash/server.xml.erb'),
    mode    => '0640',
    require => Class['stash::install'],
    notify  => Class['stash::service'],
  } ->

  file { "${stash::homedir}/${moved}stash-config.properties":
    content => template('stash/stash-config.properties.erb'),
    mode    => '0750',
    require => [
      Class['stash::install'],
      File[$stash::webappdir],
      File[$stash::homedir]
    ],
    notify  => Class['stash::service'],
  }
}

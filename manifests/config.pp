# == Class: stash
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
class stash::config {

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
    require => [ Class['stash::install'], File[$stash::webappdir], File[$stash::homedir] ],
  }->

  file { "${stash::webappdir}/conf/server.xml":
    content => template('stash/server.xml.erb'),
    mode    => '0640',
    require => Class['stash::install'],
    notify  => Class['stash::service'],
  } ->

  file { "${stash::homedir}/stash-config.properties":
    content => template('stash/stash-config.properties.erb'),
    mode    => '0750',
    require => [ Class['stash::install'], File[$stash::webappdir], File[$stash::homedir] ],
    notify  => Class['stash::service'],
  }
}

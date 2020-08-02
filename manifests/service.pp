# == Class: stash::service
#
# This manages the stash service. See README.md for details
#
class stash::service (

  Boolean $service_manage = $stash::service_manage,
  String $service_ensure  = $stash::service_ensure,
  Boolean $service_enable = $stash::service_enable,
  $service_file_location  = $stash::params::service_file_location,
  $service_file_template  = $stash::params::service_file_template,
  $service_lockfile       = $stash::params::service_lockfile,

) inherits stash::params {
  $extra_environment = $stash::product ? {
    'bitbucket' => {
      'BITBUCKET_HOME' => $stash::homedir,
      'BITBUCKET_USER' => $stash::user,
    },
    default => {
      'STASH_HOME' => $stash::homedir,
      'STASH_USER' => $stash::user,
    }
  }

  # This version number probably needs some tuning
  if versioncmp($stash::version, '6.0.0') >= 0 {
    $pidfile = "${stash::homedir}/log/bitbucket.pid"
  } else {
    $pidfile = "${stash::webappdir}/work/catalina.pid"
  }

  file { $service_file_location:
    content => epp($service_file_template),
    mode    => '0755',
  }

  if $stash::service_manage {
    if ($facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '7') or
    ($facts['os']['family'] == 'Debian' and $facts['os']['release']['full'] == '18.04') {
      exec { 'refresh_systemd':
        command     => '/bin/systemctl daemon-reload',
        refreshonly => true,
        subscribe   => File[$service_file_location],
        before      => Service['stash'],
      }
    }

    service { 'stash':
      ensure  => $service_ensure,
      enable  => $service_enable,
      require => File[$service_file_location],
    }
  }
}

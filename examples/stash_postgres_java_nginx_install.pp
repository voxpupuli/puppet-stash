node default {
  class { 'nginx': }
  -> class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.3',
  }
  -> class { 'postgresql::server': }
  -> deploy::file { 'jdk-7u71-linux-x64.tar.gz':
    target          => '/opt/java',
    fetch_options   => '-q -c --header "Cookie: oraclelicense=accept-securebackup-cookie"',
    url             => 'http://download.oracle.com/otn-pub/java/jdk/7u71-b14/',
    download_timout => 1800,
    strip           => true,
  }
  -> class { 'stash':
    version  => '3.6.0',
    javahome => '/opt/java',
    proxy    => {
      scheme    => 'http',
      proxyName => $facts['networking']['interfaces']['eth1']['ip'],
      proxyPort => '80',
    },
  }
  class { 'stash::gc': }
  class { 'stash::facts': }
  nginx::resource::upstream { 'stash':
    ensure  => present,
    members => ['localhost:7990'],
  }
  nginx::resource::vhost { $facts['networking']['interfaces']['eth1']['ip']:
    ensure               => present,
    server_name          => [$facts['networking']['interfaces']['eth1']['ip'], $facts['networking']['fqdn'], $facts['networking']['hostname']],
    listen_port          => '80',
    proxy                => 'http://stash',
    proxy_read_timeout   => '300',
    location_cfg_prepend => {
      'proxy_set_header X-Forwarded-Host'   => '$host',
      'proxy_set_header X-Forwarded-Server' => '$host',
      'proxy_set_header X-Forwarded-For'    => '$proxy_add_x_forwarded_for',
      'proxy_set_header Host'               => '$host',
      'proxy_redirect'                      => 'off',
    },
  }
  postgresql::server::db { 'stash':
    user     => 'stash',
    password => postgresql_password('stash', 'password'),
  }
}

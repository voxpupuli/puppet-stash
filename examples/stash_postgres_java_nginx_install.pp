node default {
  class { 'nginx': } ->
  class { 'postgresql::globals':
    manage_package_repo => true,
    version => '9.3',
  }->
  class { 'postgresql::server': } ->
  deploy::file { 'jdk-7u71-linux-x64.tar.gz':
    target          => '/opt/java',
    fetch_options   => '-q -c --header "Cookie: oraclelicense=accept-securebackup-cookie"',
    url             => 'http://download.oracle.com/otn-pub/java/jdk/7u71-b14/',
    download_timout => 1800,
    strip           => true,
  } ->
  class { 'stash':
    version => '3.6.0',
    javahome => '/opt/java',
    proxy => {
      scheme => 'http',
      proxyName => $::ipaddress_eth1,
      proxyPort => '80',
    },
  }
  class { 'stash::gc': }
  class { 'stash::facts': }
  nginx::resource::vhost { 'all':
    server_name => [ 'localhost', '127.0.0.1' ],
    www_root => '/vagrant/files',
  }
  nginx::resource::upstream { 'stash':
    ensure => present,
    members => [ 'localhost:7990' ],
  }
  nginx::resource::vhost { '192.168.33.10':
    ensure => present,
    server_name => [ $::ipaddress_eth1, $::fqdn, $hostname ],
    listen_port => '80',
    proxy => 'http://stash',
    proxy_read_timeout => '300',
    location_cfg_prepend => {
      'proxy_set_header X-Forwarded-Host' => '$host',
      'proxy_set_header X-Forwarded-Server' => '$host',
      'proxy_set_header X-Forwarded-For' => '$proxy_add_x_forwarded_for',
      'proxy_set_header Host' => '$host',
      'proxy_redirect' => 'off',
    }
  }
  postgresql::server::db { 'stash':
    user => 'stash',
    password => postgresql_password('stash', 'password'),
  }
}

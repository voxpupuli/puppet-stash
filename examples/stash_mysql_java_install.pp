node default {

  $version = '3.9.11'

  include ::java
  include ::git

  class { '::mysql::server':
    root_password => 'strongpassword',
  }

  -> mysql::db { 'stash':
    user     => 'stash',
    password => 'password',
    host     => 'localhost',
    grant    => ['ALL'],
  }

  -> class { '::stash':
    version  => $version,
    javahome => '/opt/java',
    dbdriver => 'com.mysql.jdbc.Driver',
  }

  -> class { '::mysql_java_connector':
    links  => [ "/opt/stash/atlassian-stash-${version}/lib" ],
    notify => Service['stash'],
  }

  class { '::stash::facts': }

}

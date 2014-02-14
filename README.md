puppet-stash
============

This is a puppet module to install stash

Requirements
------------
* Puppet 3.0+ tested 
* Puppet 2.7+
* dependency 'mkrakowitzer/deploy', '>= 0.0.1'


Example
-------
```puppet
  class { 'stash':
    version        => '2.10.1',
    installdir     => '/opt/atlassian/atlassian-stash',
    homedir        => '/opt/atlassian/application-data/stash-home',
    javahome       => '/opt/java',
    dburl          => 'jdbc:postgresql://stash.example.com:5433/stash',
    dbpassword     => $stashpass,
  }
```
Paramaters
----------
TODO

License
-------
The MIT License (MIT)

Contact
-------
Jaco Van Tonder
Merritt Krakowitzer merritt@krakowitzer.com

Support
-------

Please log tickets and issues at our [Projects site](http://github.com/mkrakowitzer/puppet-stash)

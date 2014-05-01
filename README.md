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

Testing
-------
Using [puppetlabs_spec_helper](https://github.com/puppetlabs/puppetlabs_spec_helper). Simply run:

```
bundle install && rake spec
```

to get results.

```
ruby-1.9.3-p484/bin/ruby -S rspec spec/classes/stash_install_spec.rb --color
.

Finished in 0.38159 seconds
1 example, 0 failures
```

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

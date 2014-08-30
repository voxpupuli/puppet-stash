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

Schedule a weekly git garbage collect for all repositories. 
```puppet
  class { 'stash::gc': }
```

Enable external facts for puppet version.
```puppet
  class { 'stash::facts': }
```

A complete example is available at [vagrant-puppet-stash](http://github.com/mkrakowitzer/vagrant-puppet-stash)

Customization
-------------
This module also allows for direct customization of the JVM, following [atlassians recommendations](https://confluence.atlassian.com/display/JIRA/Setting+Properties+and+Options+on+Startup)

This is especially useful for setting properties such as http/https proxy settings.

Support has also been added for reverse proxying stash via apache or nginx.

```puppet
  class { 'stash':
    version        => '2.10.1',
    installdir     => '/opt/atlassian/atlassian-stash',
    homedir        => '/opt/atlassian/application-data/stash-home',
    javahome       => '/opt/java',
    dburl          => 'jdbc:postgresql://stash.example.com:5433/stash',
    dbpassword     => $stashpass,
    jvm_support_recommended_args => '-Dhttp.proxyHost=proxy.example.com -Dhttp.proxyPort=3128 -Dhttps.proxyHost=secure-proxy.example.com -Dhttps.proxyPort=3128'
    proxy          => {
      scheme       => 'https',
      proxyName    => 'stash.example.co.za',
      proxyPort    => '443',
    },
  }
```

Paramaters
----------
####`javahome`
Specify the java home directory. No assumptions are made re the location of java and therefor this option is required. Default: undef
####`jvm_xms`
Default: '256m'
####`jvm_xmx`
Default: '1024m'
####`jvm_optional`
Default: '-XX:-HeapDumpOnOutOfMemoryError'
####`jvm_support_recommended_args`
Default: ''
####`java_opts`
Default: ''
####`version`
The version of stash to install. Default: '3.2.4'
####`format`
The format of the file stash will be installed from. Default: 'tar.gz'
####`installdir`
The installation directory of the stash binaries. Default: '/opt/stash'
####`homedir`
The home directory of stash. Configuration files are stored here. Default: '/home/stash'
####`user`
The user that stash should run as, as well as the ownership of stash related files. Default: 'stash'
####`group`
The group that stash files should be owned by. Default: 'stash'
####`uid`
Specify a uid of the stash user. Default: undef
####`gid`
Specify a gid of the stash user: Default: undef
####`dbuser`
The name of the database user that stash should use. Default: 'stash'
####`dbpassword`
The database password for the database user. Default: 'password'
####`dburl`
The uri to the stash database server. Default: 'jdbc:postgresql://localhost:5432/stash'
####`dbdriver`
The driver to use to connect to the database. Default: 'org.postgresql.Driver'
####`downloadURL`
Where to download the stash binaries from. Default: 'http://www.atlassian.com/software/stash/downloads/binary/'
####`manage_service`
Should puppet manage this service? Default: true
####`proxy`
Reverse https proxy configuration. See examples for more detail. Default: {}
####`git_version`
The version of git to install. Default: 'installed'
####`repoforge`
Enable the repoforge yum repository by default for RHEL as stash requires a newer version of git.
By default we will upgrade git if it is already installed to a supported version. Default: true

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
Support
-------
Incrementing version numbers will upgrade stash. However there is some manual steps required:
* stop stash
* increment version number
* run puppet. 
* When upgraded from <3.2.0 to >=3.2.0 puppet will not run through cleanly as stash has some migration tasks to complete. Start stash, run puppet.

Todo
----
Allow stash to upgrade automatically by incrementing the version number without manual intervention.

License
-------
The MIT License (MIT)

Contributors
------------
* Jaco Van Tonder
* Merritt Krakowitzer merritt@krakowitzer.com
* Sebastian Cole
* Geoff Williams
* Bruce Morrison


Support
-------

Please log tickets and issues at our [Projects site](http://github.com/mkrakowitzer/puppet-stash)

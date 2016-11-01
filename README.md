# Stash module for Puppet

[![Build Status](https://travis-ci.org/voxpupuli/puppet-stash.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-stash)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-stash/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-stash)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/stash.svg)](https://forge.puppetlabs.com/puppet/stash)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/stash.svg)](https://forge.puppetlabs.com/puppet/stash)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/stash.svg)](https://forge.puppetlabs.com/puppet/stash)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/stash.svg)](https://forge.puppetlabs.com/puppet/stash)

:warning: This module is going through a number of changes in preparation for
version 4 (Bitbucket-server). It is recommended to use the puppet-forge versions
and not the github master branch.

#### Table of Contents

1. [Overview](#overview)
1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with Stash](#setup)
    * [Stash Prerequisites](#Stash-prerequisites)
    * [What Stash affects](#what-Stash-affects)
    * [Beginning with Stash](#beginning-with-Stash)
    * [Upgrades](#upgrades)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)
1. [Testing - How to test the Stash module](#testing)
1. [Contributors](#contributors)

## Overview

This is a puppet module to install Atlassian Stash. On-premises source code
management for Git that's secure, fast, and enterprise grade.

|Module Version   | Support Stash versions  |
|-----------------|-------------------------|
| 1.3.0           | 3.0.0 - 3.9.2           |
| 2.0.0           | 3.9.2 - 4.x.x           |

## Module Description

This module installs/upgrades Atlassian's Enterprise source code management tool.
The Stash module also manages the stash configuration files with Puppet.

## Setup

### Stash Prerequisites

* Stash requires a Java Developers Kit (JDK) or Java Run-time Environment (JRE)
  platform to be installed on your server's operating system. Oracle JDK / JRE
  (formerly Sun JDK / JRE)  versions 7 and 8 and Open JDK/ JRE versions 7 and 8
  are currently supported by Atlassian.

* Stash requires a relational database to store its configuration data. This module
  currently supports PostgreSQL 8.4 to 9.x and MySQL 5.x. We suggest using
  puppetlabs-postgresql/puppetlabs-mysql modules to configure/manage the database.
  The module uses PostgreSQL as a default.

* Whilst not required, for production use we recommend using nginx/apache as a
  reverse proxy to Stash. We suggest using the jfryman/nginx puppet module.

### What Stash affects

If installing to an existing Stash instance, it is your responsibility to backup
your database. We also recommend that you backup your Stash home directory and
that you align your current Stash version with the version you intend to use with
puppet Stash module.

You must have your database setup with the account user that Stash will use.
This can be done using the puppetlabs-postgresql and puppetlabs-mysql modules.
The mysql java connector can be installed using the [puppet/mysql_java_connector](https://forge.puppetlabs.com/puppet/mysql_java_connector)
module.

When using this module to upgrade Stash, please make sure you have a database/Stash
home backup. We plan to include a class for backing up the stash home directory
in a future release.

When upgrading stash from < 3.8.0 to >= 3.8.0 puppet will notify the stash service
to restart for two puppet runs. This is because the stash upgrade makes file
attribute and content changes to the stash-config.properties. See issue #74

### Beginning with Stash

This puppet module will automatically download the Stash tar.gz from Atlassian and
extracts it into /opt/stash/atlassian-stash-$version. The default Stash home is /home/stash.

#### Basic examples

```puppet
  class { 'stash':
    javahome    => '/opt/java',
  }
```

```puppet
  class { 'stash':
    version        => '3.3.0',
    javahome       => '/opt/java',
    dburl          => 'jdbc:postgresql://stash.example.com:5433/stash',
    dbpassword     => $stashpass,
  }
```

Schedule a weekly git garbage collect for all repositories.

```puppet
  class { 'stash::gc': }
```

Enable external facts for stash version.

```puppet
  class { 'stash::facts': }
```

Enable a stash backup

```puppet
  class { 'stash':
    backup_ensure          => present,
    backupclient_version    => '1.6.0',
    backup_home            => '/opt/stash-backup',
    backupuser             => 'admin',
    backuppass             => 'password',
    backup_keep_age        => '3d',
    backup_schedule_hour   => '5',
    backup_schedule_minute => '0',
  }
```

##### Upgrades

###### Upgrades to Stash

Stash can be upgraded by incrementing this version number. This will *STOP* the
running instance of Stash and attempt to upgrade. You should take caution when
doing large version upgrades. Always backup your database and your home directory.
The stash::facts class is required for upgrades.

```puppet
  class { 'stash':
    javahome => '/opt/java',
    version  => '3.4.0',
  }
  class { 'stash::facts': }
```

If the stash service is managed outside of puppet the stop_stash paramater can
be used to shut down stash.

```puppet
  class { 'stash':
    javahome   => '/opt/java',
    version    => '3.4.0',
    stop_stash => 'crm resource stop stash && sleep 15',
  }
  class { 'stash::facts': }
```

## Usage

This module also allows for direct customization of the JVM, following
[Atlassian's recommendations](https://confluence.atlassian.com/display/JIRA/Setting+Properties+and+Options+on+Startup)

This is especially useful for setting properties such as HTTP/https proxy settings.
Support has also been added for reverse proxying stash via Apache or nginx.

### A more complex example

```puppet
  class { 'stash':
    version        => '2.2.0',
    installdir     => '/opt/atlassian/atlassian-stash',
    homedir        => '/opt/atlassian/application-data/stash-home',
    javahome       => '/opt/java',
    download_url    => 'http://example.co.za/pub/software/development-tools/atlassian/',
    dburl          => 'jdbc:postgresql://dbvip.example.co.za:5433/stash',
    dbpassword     => $stashpass,
    service_manage => false,
    jvm_xms        => '1G',
    jvm_xmx        => '4G',
    java_opts      => '-Dhttp.proxyHost=proxy.example.co.za -Dhttp.proxyPort=8080 -Dhttps.proxyHost=proxy.example.co.za -Dhttps.proxyPort=8080 -Dhttp.nonProxyHosts=\"localhost|127.0.0.1|172.*.*.*|10.*.*.*|*.example.co.za\"',
    proxy          => {
      scheme       => 'https',
      proxyName    => 'stash.example.co.za',
      proxyPort    => '443',
    },
    tomcat_port    => '7991'
  }
  class { 'stash::facts': }
  class { 'stash::gc': }
```

### A Hiera example

This example is used in production for 500 users in an traditional enterprise
environment. Your mileage may vary. The dbpassword can be stored using eyaml
hiera extension.

```yaml
# Stash configuration
stash::version:        '3.4.0'
stash::installdir:     '/opt/atlassian/atlassian-stash'
stash::homedir:        '/opt/atlassian/application-data/stash-home'
stash::javahome:       '/opt/java'
stash::dburl:          'jdbc:postgresql://dbvip.example.co.za:5433/stash'
stash::service_manage: false
stash::download_url:    'http://example.co.za/pub/software/development-tools/atlassian'
stash::jvm_xms:        '1G'
stash::jvm_xmx:        '4G'
stash::java_opts: >
  -XX:+UseLargePages
  -Dhttp.proxyHost=proxy.example.co.za
  -Dhttp.proxyPort=8080
  -Dhttps.proxyHost=proxy.example.co.za
  -Dhttps.proxyPort=8080
  -Dhttp.nonProxyHosts=localhost\|127.0.0.1\|172.*.*.*\|10.*.*.*\|*.example.co.za
stash::env:
  - 'http_proxy=proxy.example.co.za:8080'
  - 'https_proxy=proxy.example.co.za:8080'
stash::proxy:
  scheme:     'https'
  proxyName:  'stash.example.co.za'
  proxyPort:  '443'
stash::stash_stop: '/usr/sbin crm resource stop stash'
```

## Reference

### Classes

#### Public Classes

* `stash`: Main class, manages the installation and configuration of Stash.
* `stash::facts`: Enable external facts for running instance of Stash. This
  class is required to handle upgrades of Stash. As it is an external fact,
  we chose not to enable it by default.
* `stash::gc`: Schedule a weekly git garbage collect for all repositories
* `stash::backup`: Schedule a backup of stash

#### Private Classes

* `stash::install`: Installs Stash binaries
* `stash::config`: Modifies Stash/tomcat configuration files
* `stash::service`: Manage the Stash service.

### Parameters

#### Stash parameters

##### `javahome`

Specify the java home directory. No assumptions are made re the location of java
and therefore this option is required. Default: undef

##### `version`

Specifies the version of Stash to install, defaults to latest available at time
of module upload to the forge. It is **recommended** to pin the version number
to avoid unnecessary upgrades of Stash

##### `format`

The format of the file stash will be installed from. Default: 'tar.gz'

##### `installdir`

The installation directory of the stash binaries. Default: '/opt/stash'

##### `homedir`

The home directory of stash. Configuration files are stored here. Default: '/home/stash'

##### `manage_usr_grp`

Whether or not this module will manage the stash user and group associated with
the install. You must either allow the module to manage both aspects or handle
both outside the module. Default: true

##### `user`

The user that stash should run as, as well as the ownership of stash related
files. Default: 'stash'

##### `group`

The group that stash files should be owned by. Default: 'stash'

##### `uid`

Specify a uid of the stash user. Default: undef

##### `gid`

Specify a gid of the stash user: Default: undef

##### `context_path`

Specify context path, defaults to ''. If modified, Once Stash has started, go to
the administration area and click Server Settings (under 'Settings'). Append the
new context path to your base URL.

##### `tomcat_port`

Specify the port that you wish to run tomcat under, defaults to 7990

#### database parameters

##### `dbuser`

The name of the database user that stash should use. Default: 'stash'

##### `dbpassword`

The database password for the database user. Default: 'password'

##### `dburl`

The uri to the stash database server. Default: 'jdbc:postgresql://localhost:5432/stash'

##### `dbdriver`

The driver to use to connect to the database. Default: 'org.postgresql.Driver'

#### JVM Java parameters

##### `jvm_xms`

Default: '256m'

##### `jvm_xmx`

Default: '1024m'

##### `jvm_optional`

Default: '-XX:-HeapDumpOnOutOfMemoryError'

##### `jvm_support_recommended_args`

Default: ''

##### `java_opts`

Default: ''

#### Tomcat parameters

##### `proxy`

Reverse https proxy configuration. See examples for more detail. Default: {}

#### Miscellaneous  parameters

##### `download_url`

Where to download the stash binaries from. Default: <http://www.atlassian.com/software/stash/downloads/binary/>

##### `checksum`

The md5 checksum of the archive file. Only supported with `deploy_module => archive`.
Defaults to 'undef'

##### `service_manage`

Should puppet manage this service? Default: true

##### `$service_ensure`

Manage the stash service, defaults to 'running'

##### `$service_enable`

Defaults to 'true'

##### `$stop_stash`

If the stash service is managed outside of puppet the stop_stash paramater can be
used to shut down stash for upgrades. Defaults to 'service stash stop && sleep 15'

##### `deploy_module`

Module to use for installed stash archive fille. Supports puppet-archive and
puppet-staging. Defaults to 'archive'. Archive supports md5 hash checking,
Staging support s3 buckets.

##### `config_properties`

Extra configuration options for stash (stash-config.properties). See
<https://confluence.atlassian.com/display/STASH/Stash+config+properties>
for available options. Must be a hash, Default: {}

#### Backup parameters

##### `backup_ensure`

Enable or disable the backup cron job. Defaults to present.

##### `backupclient_version`

The version of the backup client to install. Defaults to '1.9.1'

##### `backup_home`

Home directory to use for backups. Backups are created here under /archive.
Defaults to '/opt/stash-backup'.

##### `backupuser`

The username to use to initiate the stash backup. Defaults to 'admin'

##### `backuppass`

The password to use to initiate the stash backup. Defaults to 'password'

##### `backup_keep_age`

How long to keep the backup archives for. You can choose seconds, minutes, hours,
days, or weeks by specifying the first letter of any of those words (e.g., ‘1w’).
Specifying 0 will remove all files.

##### `backup_schedule_hour`

Hour schedule for when to perform backup. Defaults to '5'.

##### `backup_schedule_minute`

Minute schedule for when to perform backup. Defaults to '0'.

## Limitations

* Puppet 3.4+
* Puppet Enterprise

The puppetlabs repositories can be found at:
<http://yum.puppetlabs.com/> and <http://apt.puppetlabs.com/>

* RedHat / CentOS 5/6/7
* Ubuntu 12.04 / 14.04
* Debian 7

We plan to support other Linux distributions and possibly Windows in the near future.

## Development

Please feel free to raise any issues here for bug fixes. We also welcome feature
requests. Feel free to make a pull request for anything and we make the effort to
review and merge. We prefer with tests if possible.

## Testing - How to test the Stash module

Using [puppetlabs_spec_helper](https://github.com/puppetlabs/puppetlabs_spec_helper).
Simply run:

```
bundle install && bundle exec rake spec
```

to get results.

```
/usr/bin/ruby1.9.1 -S rspec spec/classes/stash_config_spec.rb spec/classes/stash_facts_spec.rb spec/classes/stash_install_spec.rb spec/classes/stash_service_spec.rb spec/classes/stash_upgrade_spec.rb --color
ldapname is deprecated and will be removed in a future version
.......................

Finished in 2.02 seconds
23 examples, 0 failures
```

Using [Beaker - Puppet Labs cloud enabled acceptance testing tool.](https://github.com/puppetlabs/beaker)

run (Additional yak shaving may be required):

```
BEAKER_set=ubuntu-server-12042-x64 bundle exec rake beaker
BEAKER_set==debian-73-x64 bundle exec rake beaker
BEAKER_set==centos-64-x64 bundle exec rake beaker
```

## Contributors

* Jaco Van Tonder
* Merritt Krakowitzer merritt@krakowitzer.com
* Sebastian Cole
* Geoff Williams
* Bruce Morrison

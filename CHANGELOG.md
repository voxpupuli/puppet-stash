##2015-XX-XX - Release 2.0.0
###Summary
- Remove support for installing git, a git module should be used

##2015-07-16 - Release 1.3.0
###Summary

- Issue #58 Do not hard code java path in backup class.
- Issue #61 stash backup should be able to cleanup old archives.
- Issue #62 Add support for stash 3.8. server.xml has updated path.
- Issue #63 Add stash 3.8 automated setup options
- Issue #74 Update README.md to document upgrade issue
- Update beaker tests
- Fix rake lint tasks
- Removed reference to permgen.sh
- Add more granular control around the stash user and group.
- Fix tomcat port in service output

Thanks to Nan Liu, Stephen Schmidt, Michael Goodness

##2015-02-24 - Release 1.2.2
###Summary

- Update metadata, README, CHANGELOG to point to new namespace.

##2015-02-24 - Release 1.2.1
###Summary

Note: This is the final release of this module before it is deprecated with a 999.999.999 version. This module will be moving the the puppet-community namespace on github and the puppet namespace on puppetforge soon.

- Bump stash to the version  (3.7.0)
- Refactor spec tests to make use of rspec-puppet-facts gem
- Add sudo: false to travis file.
- fix issue where git gc scripts has incorrect repo path for version 3.2+

##2015-02-24 - Release 1.2.0
###Summary
- refacter params.pp for puppetlabs approved
- remove if packaged defined block, module should be explicit about what it is managing.
- Bump default stash version
- Add examples to examples directory
- Add class to backup stash
  - Thanks to Tim Hartmann +1

#
##2014-11-15 - Release 1.1.3
###Summary
- Add parameter context_path
- Add RHEL/CentOS 7 support
- Add Ubuntu 14.04 support
- Update beaker tests
- Only upgrade git on osfamily redhat version 6
##2014-11-15 - Release 1.1.2
###Summary
- rename parameter manage_service to service_manage
- Fix Issue #30 Add params for stash::service
##2014-10-26 - Release 1.1.1
###Summary
- Replace mkrakowitzer-deploy with nanliu-staging as the default to deploy the install file.
- Add new parameter: jvm_permgen, defaults to 256m.
- Add $stop_stash parameter, This is usefull for when service is managed outside of the module,
such as in a cluster.
- Add test for upgrades
- Update the README file to comply with puppetlabs standards
  - https://docs.puppetlabs.com/puppet/latest/reference/modules_documentation.html
  - https://docs.puppetlabs.com/puppet/latest/reference/READMEtemplate.markdown

####Bugfixes
- None

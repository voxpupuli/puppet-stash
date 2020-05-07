# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v4.0.0](https://github.com/voxpupuli/puppet-stash/tree/v4.0.0) (2020-05-07)

[Full Changelog](https://github.com/voxpupuli/puppet-stash/compare/v3.1.2...v4.0.0)

**Breaking changes:**

- Add Bitbucket 6 compatibility [\#189](https://github.com/voxpupuli/puppet-stash/pull/189) ([dickp](https://github.com/dickp))
- modulesync 2.7.0 and drop puppet 4 [\#180](https://github.com/voxpupuli/puppet-stash/pull/180) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Exec clause in service class conflicts with Jira module [\#151](https://github.com/voxpupuli/puppet-stash/issues/151)

**Merged pull requests:**

- Remove duplicate CONTRIBUTING.md file [\#186](https://github.com/voxpupuli/puppet-stash/pull/186) ([dhoppe](https://github.com/dhoppe))
- allow puppetlabs/inifile 4.x [\#185](https://github.com/voxpupuli/puppet-stash/pull/185) ([bastelfreak](https://github.com/bastelfreak))
- Clean up acceptance spec helper [\#184](https://github.com/voxpupuli/puppet-stash/pull/184) ([ekohl](https://github.com/ekohl))
- Allow `puppetlabs/stdlib` 6.x and `puppet/archive` 4.x [\#182](https://github.com/voxpupuli/puppet-stash/pull/182) ([alexjfisher](https://github.com/alexjfisher))
- Allow puppetlabs/inifile 3.x [\#181](https://github.com/voxpupuli/puppet-stash/pull/181) ([dhoppe](https://github.com/dhoppe))

## [v3.1.2](https://github.com/voxpupuli/puppet-stash/tree/v3.1.2) (2018-10-20)

[Full Changelog](https://github.com/voxpupuli/puppet-stash/compare/v3.1.1...v3.1.2)

**Merged pull requests:**

- modulesync 2.2.0 and allow puppet 6.x [\#176](https://github.com/voxpupuli/puppet-stash/pull/176) ([bastelfreak](https://github.com/bastelfreak))

## [v3.1.1](https://github.com/voxpupuli/puppet-stash/tree/v3.1.1) (2018-09-07)

[Full Changelog](https://github.com/voxpupuli/puppet-stash/compare/v3.1.0...v3.1.1)

**Merged pull requests:**

- puppet/archive 3.x and puppet/staging 3.x [\#174](https://github.com/voxpupuli/puppet-stash/pull/174) ([bastelfreak](https://github.com/bastelfreak))
- allow puppetlabs/stdlib 5.x [\#172](https://github.com/voxpupuli/puppet-stash/pull/172) ([bastelfreak](https://github.com/bastelfreak))
- Remove docker nodesets [\#169](https://github.com/voxpupuli/puppet-stash/pull/169) ([bastelfreak](https://github.com/bastelfreak))
- drop EOL OSs; fix puppet version range [\#167](https://github.com/voxpupuli/puppet-stash/pull/167) ([bastelfreak](https://github.com/bastelfreak))

## [v3.1.0](https://github.com/voxpupuli/puppet-stash/tree/v3.1.0) (2018-03-28)

[Full Changelog](https://github.com/voxpupuli/puppet-stash/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- Add ajp\_port parameter [\#157](https://github.com/voxpupuli/puppet-stash/pull/157) ([dlucredativ](https://github.com/dlucredativ))

**Fixed bugs:**

- Pulling in product name from stash config for init scripts [\#156](https://github.com/voxpupuli/puppet-stash/pull/156) ([johnlawerance](https://github.com/johnlawerance))

**Closed issues:**

- Fix init scripts with product support [\#155](https://github.com/voxpupuli/puppet-stash/issues/155)

**Merged pull requests:**

- bump puppet to latest supported version 4.10.0 [\#165](https://github.com/voxpupuli/puppet-stash/pull/165) ([bastelfreak](https://github.com/bastelfreak))

## [v3.0.0](https://github.com/voxpupuli/puppet-stash/tree/v3.0.0) (2017-10-18)

[Full Changelog](https://github.com/voxpupuli/puppet-stash/compare/v2.0.0...v3.0.0)

**Merged pull requests:**

- Update dependency versions [\#159](https://github.com/voxpupuli/puppet-stash/pull/159) ([bastelfreak](https://github.com/bastelfreak))
- replace validate\_\* with puppet4 datatypes [\#154](https://github.com/voxpupuli/puppet-stash/pull/154) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/puppet-stash/tree/v2.0.0) (2017-02-11)
### Summary
- Remove support for installing upstream java mysql connector
- Remove support for installing git, a git module should be used
- Issue #85 - add global parameter for stash-config.properties values
- Issue #87 - URL structure has changed
- Fix broken backupclientURL
- add a sync.yml to override .travis.yml and spec/helper
- Adding backup cron hour/min params
- Remove uppercase parameter/variable names
- Add lint plugins, lint fixes
- Set mysql driver in stash-config.properties
- Fix dependencies and namespace
- Check for required parameter javahome
- Fix several markdown issues
- Add missing badges
- Fix several rubocop issues
- Use https instead of http (#138)
- Bump min version_requirement for Puppet + deps

## 2015-07-16 - Release 1.3.0
### Summary

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

## 2015-02-24 - Release 1.2.2
### Summary

- Update metadata, README, CHANGELOG to point to new namespace.

## 2015-02-24 - Release 1.2.1
### Summary

Note: This is the final release of this module before it is deprecated with a 999.999.999 version. This module will be moving the the puppet-community namespace on github and the puppet namespace on puppetforge soon.

- Bump stash to the version  (3.7.0)
- Refactor spec tests to make use of rspec-puppet-facts gem
- Add sudo: false to travis file.
- fix issue where git gc scripts has incorrect repo path for version 3.2+

## 2015-02-24 - Release 1.2.0
### Summary
- refacter params.pp for puppetlabs approved
- remove if packaged defined block, module should be explicit about what it is managing.
- Bump default stash version
- Add examples to examples directory
- Add class to backup stash
  - Thanks to Tim Hartmann +1

#
## 2014-11-15 - Release 1.1.3
### Summary
- Add parameter context_path
- Add RHEL/CentOS 7 support
- Add Ubuntu 14.04 support
- Update beaker tests
- Only upgrade git on osfamily redhat version 6
## 2014-11-15 - Release 1.1.2
### Summary
- rename parameter manage_service to service_manage
- Fix Issue #30 Add params for stash::service
## 2014-10-26 - Release 1.1.1
### Summary
- Replace mkrakowitzer-deploy with nanliu-staging as the default to deploy the install file.
- Add new parameter: jvm_permgen, defaults to 256m.
- Add $stop_stash parameter, This is usefull for when service is managed outside of the module,
such as in a cluster.
- Add test for upgrades
- Update the README file to comply with puppetlabs standards
  - https://docs.puppetlabs.com/puppet/latest/reference/modules_documentation.html
  - https://docs.puppetlabs.com/puppet/latest/reference/READMEtemplate.markdown

### Bugfixes
- None


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*

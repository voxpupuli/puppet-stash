require 'spec_helper_acceptance'
# These tests are designed to ensure that the module, when ran with defaults,
# sets up everything correctly and allows us to connect to stash.

proxyurl = ENV['http_proxy'] if ENV['http_proxy']

# We add the sleeps everywhere to give stash enough
# time to install/upgrade/run migration tasks/start/

describe 'stash', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  it 'installs with defaults' do
    pp = <<-EOS
      $jh = $osfamily ? {
        'RedHat'  => '/usr/lib/jvm/java-1.7.0-openjdk.x86_64',
        'Debian'  => '/usr/lib/jvm/java-7-openjdk-amd64',
        default   => '/opt/java',
      }
      if versioncmp($::puppetversion,'3.6.1') >= 0 {
        $allow_virtual_packages = hiera('allow_virtual_packages',false)
        Package {
          allow_virtual => $allow_virtual_packages,
        }
      }
     class { 'postgresql::globals':
        manage_package_repo => true,
        version             => '9.3',
      }->
      class { 'postgresql::server': } ->
      class { 'java':
        distribution => 'jdk',
      } ->
      class { 'stash':
        downloadURL => 'http://10.0.0.12/',
        version     => '3.2.4',
        javahome    => $jh,
      }
      class { 'stash::gc': }
      class { 'stash::facts': }
      postgresql::server::db { 'stash':
        user     => 'stash',
        password => postgresql_password('stash', 'password'),
      }
    EOS
    apply_manifest(pp, :catch_failures => true)
    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:7990', :acceptable_exit_codes => [0]
    sleep 120
    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:7990', :acceptable_exit_codes => [0]
    sleep 60
    apply_manifest(pp, :catch_changes => true)
  end

  it 'upgrades with defaults' do
    pp_update = <<-EOS
      $jh = $osfamily ? {
        'RedHat'  => '/usr/lib/jvm/java-1.7.0-openjdk.x86_64',
        'Debian'  => '/usr/lib/jvm/java-7-openjdk-amd64',
        default   => '/opt/java',
      }
      class { 'stash':
        version     => '3.3.0',
        downloadURL => 'http://10.0.0.12/',
        javahome    => $jh,
      }
    EOS
    sleep 180
    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:7990', :acceptable_exit_codes => [0]
    apply_manifest(pp_update, :catch_failures => true)
    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:7990', :acceptable_exit_codes => [0]
    sleep 180
    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:7990', :acceptable_exit_codes => [0]
    apply_manifest(pp_update, :catch_changes => true)
  end

  describe process("java") do
    it { should be_running }
  end

  describe port(7990) do
    it { is_expected.to be_listening }
  end

  describe package('git') do
    it { should be_installed }
  end

  describe service('stash') do
    it { should be_enabled }
  end

  describe user('stash') do
    it { should exist }
  end

  describe user('stash') do
    it { should belong_to_group 'stash' }
  end

  describe user('stash') do
    it { should have_login_shell '/bin/bash' }
  end

end

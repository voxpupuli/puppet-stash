require 'spec_helper_acceptance'

# It is sometimes faster to host jira / java files on a local webserver.
# Set environment variable download_url to use local webserver
# export download_url = 'http://10.0.0.XXX/'
download_url = ENV['download_url'] if ENV['download_url']
if ENV['download_url'] then
  download_url = ENV['download_url']
else
  download_url = 'undef'
end
if download_url == 'undef' then
  java_url = "'http://download.oracle.com/otn-pub/java/jdk/7u71-b14/'"
else
  java_url = download_url
end

# We add the sleeps everywhere to give stash enough
# time to install/upgrade/run migration tasks/start

describe 'stash', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  it 'installs with defaults' do
    pp = <<-EOS
      $jh = $osfamily ? {
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
      postgresql::server::db { 'stash':
        user     => 'stash',
        password => postgresql_password('stash', 'password'),
      } ->
      deploy::file { 'jdk-7u71-linux-x64.tar.gz':
        target          => '/opt/java',
        fetch_options   => '-q -c --header "Cookie: oraclelicense=accept-securebackup-cookie"',
        url             => #{java_url},
        download_timout => 1800,
        strip           => true,
      } ->
      class { 'stash':
        downloadURL => #{download_url},
        version     => '3.2.4',
        javahome    => $jh,
        context_path => '/stash1',
      }
      class { 'stash::gc': }
      class { 'stash::facts': }
   EOS
    apply_manifest(pp, :catch_failures => true)
    sleep 180
    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:7990/stash1', :acceptable_exit_codes => [0]
    sleep 180
    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:7990/stash1', :acceptable_exit_codes => [0]
    apply_manifest(pp, :catch_changes => true)
    sleep 180
    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:7990/stash1', :acceptable_exit_codes => [0]
  end

  it 'upgrades with defaults' do
    pp_update = <<-EOS
      if versioncmp($::puppetversion,'3.6.1') >= 0 {
        $allow_virtual_packages = hiera('allow_virtual_packages',false)
        Package {
          allow_virtual => $allow_virtual_packages,
        }
      }
      $jh = $osfamily ? {
        default   => '/opt/java',
      }
      class { 'stash':
        version     => '3.3.0',
        downloadURL => #{download_url},
        javahome    => $jh,
        context_path => '/stash1',
      }
    EOS
    apply_manifest(pp_update, :catch_failures => true)
    sleep 180
    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:7990/stash1', :acceptable_exit_codes => [0]
    sleep 180
    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:7990/stash1', :acceptable_exit_codes => [0]
    sleep 50
    apply_manifest(pp_update, :catch_changes => true)
    sleep 10
    shell 'wget -q --tries=180 --retry-connrefused --read-timeout=10 localhost:7990/stash1', :acceptable_exit_codes => [0]
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
    it { should have_login_shell '/bin/true' }
  end

  describe command('curl http://localhost:7990/stash1/setup') do
    its(:stdout) { should match /This is the base URL of this installation of Stash/ }
  end

#  describe command('sleep 10000') do
#    its(:stdout) { should match /This is the base URL of this installation of Stash/ }
#  end
end

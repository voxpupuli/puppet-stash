require 'spec_helper_acceptance'

download_url = ENV['download_url'] if ENV['download_url']
download_url = if ENV['download_url']
                 ENV['download_url']
               else
                 'undef'
               end

# We add the sleeps everywhere to give stash enough
# time to install/upgrade/run migration tasks/start

describe 'stash', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'upgrades to 4.0.2 with defaults and context /stash1' do
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
        version       => '3.11.4',
        deploy_module => 'staging',
        download_url   => #{download_url},
        javahome      => $jh,
        context_path  => '/stash1',
      }
      include ::stash::facts
    EOS
    apply_manifest(pp_update, :catch_failures => true)
    shell 'wget -q --tries=20 --retry-connrefused --read-timeout=10 localhost:7990/stash1'
    sleep 180
    apply_manifest(pp_update, :catch_failures => true)
    shell 'wget -q --tries=20 --retry-connrefused --read-timeout=10 localhost:7990/stash1', :acceptable_exit_codes => [0]
    sleep 120
    apply_manifest(pp_update, :catch_changes => true)
    shell 'wget -q --tries=20 --retry-connrefused --read-timeout=10 localhost:7990/stash1', :acceptable_exit_codes => [0]
  end

  describe process('java') do
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

  describe command('curl http://localhost:7990/stash1/setup') do
    its(:stdout) { should match(/This is the base URL of this installation of Stash/) }
  end

  describe command('facter -p stash_version') do
    its(:stdout) { should match(/3\.11\.4/) }
  end
end

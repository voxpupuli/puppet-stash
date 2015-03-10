require 'spec_helper'

describe 'stash' do
describe 'stash::install' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os} #{facts}" do
        let(:facts) do
          facts
        end
        context 'install stash with deploy module' do
          let(:params) {{
            :version => '3.6.1',
          }}
          it 'should install, but not upgrade, git' do
            should contain_package('git').with_ensure('installed')
          end
          it { should contain_group('stash') }
          it { should contain_user('stash').with_shell('/bin/true') }
          it 'should deploy stash from tar.gz' do
            str = "atlassian-stash-3.6.1.tar.gz"
            should contain_staging__file(str).with({
              'source' => 'http://www.atlassian.com/software/stash/downloads/binary//atlassian-stash-3.6.1.tar.gz',
              })
          end
          it 'should manage the stash home directory' do
            should contain_file('/home/stash').with({
              'ensure' => 'directory',
              'owner' => 'stash',
              'group' => 'stash'
              })
          end
        end
      
        context 'overwriting params' do
          let(:params) {{
            :version     => '3.6.1',
            :product     => 'stash',
            :format      => 'tar.gz',
            :installdir  => '/opt/stash',
            :homedir     => '/random/homedir',
            :user        => 'foo',
            :group       => 'bar',
            :uid         => 333,
            :gid         => 444,
            :shell       => '/bin/bash',
            :downloadURL => 'http://downloads.atlassian.com/',
            :git_version => 'installed',
          }}
          it do
            should contain_user('foo').with({
              'home'  => '/random/homedir',
              'shell' => '/bin/bash',
              'uid'   => 333,
              'gid'   => 444
             })
          end
          it { should contain_group('bar') }
          it 'should deploy stash 3.6.1 from tar.gz' do
            should contain_staging__file("atlassian-stash-3.6.1.tar.gz").with({
              'source' => 'http://downloads.atlassian.com//atlassian-stash-3.6.1.tar.gz',
              })
          end 
          it 'should manage the stash home directory' do
            should contain_file('/random/homedir').with({
              'ensure' => 'directory',
              'owner' => 'foo',
              'group' => 'bar'
              })
          end
        end
      
        context 'specify git version' do
          let(:params) {{
            :version => '3.6.1',
            :git_version => '1.7.12',
            :staging_or_deploy => 'deploy',
          }}
          it 'should ensure a specific version of git is installed' do
            should contain_package('git').with_ensure('1.7.12')
          end
          it { should contain_group('stash') }
          it { should contain_user('stash').with_shell('/bin/true') }
          it 'should deploy stash from tar.gz' do
            should contain_deploy__file("atlassian-stash-3.6.1.tar.gz")
          end
          it 'should manage the stash home directory' do
            should contain_file('/home/stash').with({
              'ensure' => 'directory',
              'owner' => 'stash',
              'group' => 'stash'
            })
          end
        end
      end
    end
  end
end
end

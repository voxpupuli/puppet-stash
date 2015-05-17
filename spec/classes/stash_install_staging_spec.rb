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
            :version => '3.7.0',
          }}
          it 'should install, but not upgrade, git' do
            should contain_package('git').with_ensure('installed')
          end
          it { should contain_group('stash') }
          it { should contain_user('stash').with_shell('/bin/bash') }
          it 'should deploy stash from tar.gz' do
	    str = "atlassian-stash-3.7.0.tar.gz"
            should contain_staging__file(str).with({
              'source' => 'http://www.atlassian.com/software/stash/downloads/binary//atlassian-stash-3.7.0.tar.gz',
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
      
        context 'when managing the user and group outside the module' do
          let(:params) {{
            :user_manage  => 'false',
            :group_manage => 'false',
          }}
          context 'when no user or group are specified' do
            it do
              should_not contain_user('stash').with({
                'comment'          => 'Stash daemon account',
                'shell'            => '/bin/bash',
                'home'             => '/test/my/dir',
                'password'         => '*',
                'password_min_age' => '0',
                'password_max_age' => '99999',
                'managehome'       => true,
                'uid'              => '1234',
                'gid'              => '5678' 
              })
            end 
            it do
              should_not contain_group('stash').with({
                'ensure' => 'present',
                'gid'    => '5678' 
              })
            end
          end
          context 'when a user and group is specified' do
            let(:params) {{
              :user  => 'mystashuser',
              :group => 'mystashgroup'
            }}
            it do
              should_not contain_user('mystashuser').with({
                'comment'          => 'Stash daemon account',
                'shell'            => '/bin/bash',
                'home'             => '/test/my/dir',
                'password'         => '*',
                'password_min_age' => '0',
                'password_max_age' => '99999',
                'managehome'       => true,
                'uid'              => '1234',
                'gid'              => '5678' 
              })
            end 
            it do
              should_not contain_group('mystashgroup').with({
                'ensure' => 'present',
                'gid'    => '5678'
              })
            end
          end
        end

        #context 'when managing the user and group inside the module' do
        #  let(:params) {{
        #    :user_manage  => 'true',
        #    :group_manage => 'true'
        #  }}
        #  context 'when no user or group are specified' do
        #    it { should contain_user('stash') }
        #    it { should contain_group('stash') }
        #  end
        #  context 'when a user and group is specified' do
        #    let(:params) {{
        #      :user  => 'mystashuser',
        #      :group => 'mystashgroup'
        #    }}
        #    it { should contain_user('mystashuser') }
        #    it { should contain_group('mystashgroup') }
        #  end
        #end

        context 'overwriting params' do
          let(:params) {{
            :version     => '3.7.0',
            :product     => 'stash',
            :format      => 'tar.gz',
            :installdir  => '/opt/stash',
            :homedir     => '/random/homedir',
            :user        => 'foo',
            :group       => 'bar',
            :uid         => 333,
            :gid         => 444,
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
          it 'should deploy stash 3.7.0 from tar.gz' do
            should contain_staging__file("atlassian-stash-3.7.0.tar.gz").with({
              'source' => 'http://downloads.atlassian.com//atlassian-stash-3.7.0.tar.gz',
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
            :version => '3.7.0',
            :git_version => '1.7.12',
            :staging_or_deploy => 'deploy',
          }}
          it 'should ensure a specific version of git is installed' do
            should contain_package('git').with_ensure('1.7.12')
          end
          it { should contain_group('stash') }
          it { should contain_user('stash').with_shell('/bin/bash') }
          it 'should deploy stash from tar.gz' do
            should contain_deploy__file("atlassian-stash-3.7.0.tar.gz")
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

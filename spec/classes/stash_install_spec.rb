require 'spec_helper'

describe 'stash' do
  describe 'stash::install' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os} #{facts}" do
          let(:facts) do
            facts
          end
          let(:params) do
            {
              version: STASH_VERSION,
              javahome: '/opt/java',
            }
          end

          it 'should deploy stash from archive' do
            should contain_archive("/tmp/atlassian-stash-#{STASH_VERSION}.tar.gz")
              .with('extract_path' => "/opt/stash/atlassian-stash-#{STASH_VERSION}",
                    'source' => "http://www.atlassian.com/software/stash/downloads/binary//atlassian-stash-#{STASH_VERSION}.tar.gz",
                    'creates' => "/opt/stash/atlassian-stash-#{STASH_VERSION}/conf",
                    'user' => 'stash',
                    'group' => 'stash',
                    'checksum_type' => 'md5',)
          end

          it 'should manage the stash home directory' do
            should contain_file('/home/stash')
              .with('ensure' => 'directory',
                    'owner' => 'stash',
                    'group' => 'stash')
          end

          it 'should manage the stash application directory' do
            should contain_file("/opt/stash/atlassian-stash-#{STASH_VERSION}")
              .with('ensure' => 'directory',
                    'owner' => 'stash',
                    'group' => 'stash')
          end

          context 'when managing the user and group inside the module' do
            let(:params) do
              {
                javahome: '/opt/java',
                manage_usr_grp: true,
              }
            end
            context 'when no user or group are specified' do
              it { should contain_user('stash').with_shell('/bin/bash') }
              it { should contain_group('stash') }
            end
            context 'when a user and group is specified' do
              let(:params) do
                {
                  javahome: '/opt/java',
                  user: 'mystashuser',
                  group: 'mystashgroup'
                }
              end
              it { should contain_user('mystashuser') }
              it { should contain_group('mystashgroup') }
            end
          end

          context 'when managing the user and group outside the module' do
            context 'when no user or group are specified' do
              let(:params) do
                {
                  javahome: '/opt/java',
                  manage_usr_grp: false,
                }
              end
              it { should_not contain_user('stash') }
              it { should_not contain_group('stash') }
            end
          end

          context 'overwriting params' do
            let(:params) do
              {
                version: STASH_VERSION,
                javahome: '/opt/java',
                installdir: '/custom/stash',
                homedir: '/random/homedir',
                user: 'foo',
                group: 'bar',
                uid: 333,
                gid: 444,
                download_url: 'http://downloads.atlassian.com/',
                deploy_module: 'staging',
              }
            end
            it do
              should contain_staging__file("atlassian-stash-#{STASH_VERSION}.tar.gz")
                .with('source' => "http://downloads.atlassian.com//atlassian-stash-#{STASH_VERSION}.tar.gz",)
              should contain_staging__extract("atlassian-stash-#{STASH_VERSION}.tar.gz")
                .with('target'  => "/custom/stash/atlassian-stash-#{STASH_VERSION}",
                      'user'    => 'foo',
                      'group'   => 'bar',
                      'creates' => "/custom/stash/atlassian-stash-#{STASH_VERSION}/conf",)
                .that_comes_before('File[/random/homedir]')
                .that_requires('File[/custom/stash]')
                .that_notifies("Exec[chown_/custom/stash/atlassian-stash-#{STASH_VERSION}]")
            end

            it do
              should contain_user('foo').with('home'  => '/random/homedir',
                                              'shell' => '/bin/bash',
                                              'uid'   => 333,
                                              'gid'   => 444)
            end
            it { should contain_group('bar') }
            it 'should manage the stash home directory' do
              should contain_file('/random/homedir').with('ensure' => 'directory',
                                                          'owner' => 'foo',
                                                          'group' => 'bar')
            end
          end
        end
      end
    end
  end
end

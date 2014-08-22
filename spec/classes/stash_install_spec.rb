require 'spec_helper.rb'

describe 'stash::install' do

  context 'default params' do
    let(:params) {{
      :user  => 'stash',
      :group => 'stash',
      :installdir => '/opt/stash',
      :homedir => '/home/stash',
      :format => 'tar.gz',
      :product => 'stash',
      :version => '2.12.0',
      :downloadURL => 'http://www.atlassian.com/software/stash/downloads/binary/',
      :webappdir => '/opt/stash/atlassian-stash-2.12.0',
      :git_version => 'installed'
      }}

    it 'should install, but not upgrade, git' do
      should contain_package('git').with_ensure('installed')
    end
    it { should contain_group('stash') }
    it { should contain_user('stash').with_shell('/bin/bash') }
    it 'should deploy stash 2.12.0 from tar.gz' do
      should contain_deploy__file("atlassian-stash-2.12.0.tar.gz")
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
      :version => '2.12.0',
      :product => 'stash',
      :format => 'tar.gz',
      :installdir => '/opt/stash',
      :homedir => '/random/homedir',
      :user  => 'foo',
      :group => 'bar',
      :uid   => 333,
      :gid   => 444,
      :downloadURL => 'http://downloads.atlassian.com/',
      :webappdir => '/somewhere/stash',
      :git_version => 'installed'
      }}

    it { should contain_user('foo').with({
        'home'  => '/random/homedir',
        'shell' => '/bin/bash',
        'uid'   => 333,
        'gid'   => 444
      }) }
    it { should contain_group('bar') }

    it 'should deploy stash 2.12.0 from tar.gz' do
      should contain_deploy__file("atlassian-stash-2.12.0.tar.gz").with({
        'url' => 'http://downloads.atlassian.com/',
        'owner' => 'foo',
        'group' => 'bar'
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

end
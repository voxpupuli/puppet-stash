require 'spec_helper.rb'

describe 'stash' do
describe 'stash::install' do

  it 'should install, but not upgrade, git' do
    should contain_package('git').with_ensure('installed')
  end

  context 'default params' do
    it { should contain_group('stash') }
    it { should contain_user('stash') }
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

end
end
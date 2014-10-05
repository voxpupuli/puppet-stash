require 'spec_helper.rb'

describe 'stash' do
  context 'prepare for upgrade of stash' do
    let(:params) {{ :version => '3.3.3' }}
    let(:facts) {{ :stash_version => "2.10.1" }}
    it {
      should contain_exec('service stash stop && sleep 15').with({
         :command => 'service stash stop && sleep 15',
      })
      should contain_exec('rm -f /home/stash/stash-config.properties').with({
         :command => 'rm -f /home/stash/stash-config.properties',
      })
    }
  end
end

require 'spec_helper.rb'

describe 'stash' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os} #{facts}" do
        let(:facts) do
          facts
        end
        context 'prepare for upgrade of stash' do
          let(:params) do
            { :javahome => '/opt/java' }
          end
          let(:facts) do
            facts.merge(:stash_version => '3.1.0')
          end
          it 'should stop service and remove old config file' do
            should contain_exec('service stash stop && sleep 15')
            should contain_exec('rm -f /home/stash/stash-config.properties')
              .with(:command => 'rm -f /home/stash/stash-config.properties',)
            should contain_notify('Attempting to upgrade stash')
          end
        end
      end
    end
  end
end

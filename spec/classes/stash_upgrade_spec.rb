require 'spec_helper.rb'

describe 'stash' do
  describe 'stash::install' do
    context 'default params' do
      let(:params) {{
        :javahome    => '/opt/java',
      }}
      let(:facts) { {
        :stash_version  => "3.1.0",
      }}
       it 'should stop service and remove old config file' do
         should contain_exec('service stash stop && sleep 15')
         should contain_exec('rm -f /home/stash/stash-config.properties')
      end
    end
  end
end

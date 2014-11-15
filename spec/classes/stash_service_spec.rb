require 'spec_helper.rb'

describe 'stash' do
  describe 'stash::service' do
    context 'default params' do
      it { should contain_service('stash')}
    end
    context 'overwriting service_manage param' do
      let(:params) {{
        :service_manage => false,
      }}
      it { should_not contain_service('stash')}
    end
    context 'overwriting service params' do
      let(:params) {{
        :service_ensure => 'stopped',
        :service_enable => false,
      }}
      it { should contain_service('stash').with({
        'ensure' => 'stopped',
        'enable' => 'false',
      })}
    end
  end
end

require 'spec_helper.rb'

describe 'stash' do
describe 'stash::config' do
  context 'default params' do
    let(:params) {{
      :version => '3.2.4',
    }}
    it { should contain_file('/opt/stash/atlassian-stash-3.2.4/bin/setenv.sh')}
    it { should contain_file('/opt/stash/atlassian-stash-3.2.4/bin/user.sh')}
    it { should contain_file('/opt/stash/atlassian-stash-3.2.4/conf/server.xml')}
    it { should contain_file('/home/stash/shared/stash-config.properties')}
  end
end
end

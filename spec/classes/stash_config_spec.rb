require 'spec_helper.rb'

describe 'stash' do
describe 'stash::config' do
	context 'default params' do
		it { should contain_file('/opt/stash/atlassian-stash-2.12.0/bin/setenv.sh')}
		it { should contain_file('/opt/stash/atlassian-stash-2.12.0/bin/user.sh')}
		it { should contain_file('/opt/stash/atlassian-stash-2.12.0/conf/server.xml')}
		it { should contain_file('/home/stash/stash-config.properties')}
	end
end
end

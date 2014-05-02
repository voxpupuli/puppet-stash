require 'spec_helper.rb'

describe 'stash' do
describe 'stash::config' do
	context 'default params' do
		it { should contain_service('stash')}
	end
end
end

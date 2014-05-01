require 'spec_helper.rb'

describe 'stash' do
  context 'default params' do
    it do
      should contain_class('stash::install')
      should contain_class('stash::config')
      should contain_class('stash::service')
    end

  end

  
end
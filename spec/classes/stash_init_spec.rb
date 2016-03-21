require 'spec_helper'

describe 'stash' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os} #{facts}" do
        let(:facts) do
          facts
        end
        context 'with javahome not set' do
          it('should fail') {
            should raise_error(Puppet::Error, /You need to specify a value for javahome/)
          }
        end
        context 'with javahome set' do
          let(:params) do
            { :javahome => '/opt/java' }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('stash') }
          it { is_expected.to contain_class('stash::params') }
          it { is_expected.to contain_anchor('stash::start').that_comes_before('stash::install') }
          it { is_expected.to contain_class('stash::install').that_comes_before('stash::config') }
          it { is_expected.to contain_class('stash::config') }
          it { is_expected.to contain_class('stash::backup') }
          it { is_expected.to contain_class('stash::service').that_subscribes_to('stash::config') }
          it { is_expected.to contain_anchor('stash::end').that_requires('stash::service') }
          it { is_expected.to contain_class('archive') }
          it { is_expected.to contain_service('stash') }
        end
      end
    end
  end
  context 'unsupported operating system' do
    describe 'test class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        { :osfamily => 'Solaris',
          :operatingsystem => 'Nexenta',
          :operatingsystemmajrelease => '7',
        }
      end

      it { expect { is_expected.to contain_service('stash') }.to raise_error(Puppet::Error, /Nexenta 7 not supported/) }
    end
  end
end

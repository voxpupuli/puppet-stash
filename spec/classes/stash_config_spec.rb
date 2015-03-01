require 'spec_helper'

describe 'stash' do
describe 'stash::config' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os} #{facts}" do
        let(:facts) do
          facts
        end

        context 'default params' do
          let(:params) do
            {
              :javahome  => '/opt/java',
              :version   => '3.6.1',
           }
          end
          it do should contain_file('/opt/stash/atlassian-stash-3.6.1/bin/setenv.sh') \
             .with_content(/JAVA_HOME=\/opt\/java/)
          end
          it { should contain_file('/opt/stash/atlassian-stash-3.6.1/bin/user.sh')}
          it { should contain_file('/opt/stash/atlassian-stash-3.6.1/conf/server.xml')}
          it { should contain_file('/home/stash/shared/stash-config.properties')}
        end

        context 'proxy settings ' do
          let(:params) {{
            :version     => '3.6.1',
            :proxy   => {
              'scheme'    => 'https',
              'proxyName' => 'stash.example.co.za',
              'proxyPort' => '443',
            },
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.6.1/conf/server.xml') \
              .with_content(/proxyName = \'stash\.example\.co\.za\'/)
              .with_content(/proxyPort = \'443\'/)
              .with_content(/scheme = \'https\'/)
              .with_content(/path=""/)
          end
        end

        context 'jvm_xms => 1G' do
          let(:params) {{
            :version => '3.6.1',
            :jvm_xms => '1G',
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.6.1/bin/setenv.sh')
              .with_content(/^JVM_MINIMUM_MEMORY="1G"/)
          end
        end

        context 'jvm_xmx => 4G' do
          let(:params) {{
            :version => '3.6.1',
            :jvm_xmx => '4G',
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.6.1/bin/setenv.sh')
              .with_content(/^JVM_MAXIMUM_MEMORY="4G"/)
          end
        end

        context 'jvm_permgen => 384m' do
          let(:params) {{
            :version     => '3.6.1',
            :jvm_permgen => '384m',
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.6.1/bin/setenv.sh')
              .with_content(/^STASH_MAX_PERM_SIZE=384m/)
          end
        end

        context 'java_opts => "-Dhttp.proxyHost=proxy.example.co.za -Dhttp.proxyPort=8080"' do
          let(:params) {{
            :version     => '3.6.1',
            :java_opts   => '-Dhttp.proxyHost=proxy.example.co.za -Dhttp.proxyPort=8080',
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.6.1/bin/setenv.sh')
              .with_content(/JAVA_OPTS="-Dhttp\.proxyHost=proxy\.example\.co\.za -Dhttp\.proxyPort=8080/)
          end
        end

        context 'context_path => "stash"' do
          let(:params) {{
            :version      => '3.6.1',
            :context_path => '/stash',
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.6.1/conf/server.xml')
              .with_content(/path="\/stash"/)
          end
        end
      end
    end
  end
end
end

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
              :version   => '3.7.0',
              :tomcat_port => '7990',
           }
          end
          it do
            should contain_file('/opt/stash/atlassian-stash-3.7.0/bin/setenv.sh') \
              .with_content(/JAVA_HOME=\/opt\/java/)
              .with_content(/^JVM_MINIMUM_MEMORY="256m"/)
              .with_content(/^JVM_MAXIMUM_MEMORY="1024m"/)
              .with_content(/^STASH_MAX_PERM_SIZE=256m/)
              .with_content(/JAVA_OPTS="/)

          end
          it { should contain_file('/opt/stash/atlassian-stash-3.7.0/bin/user.sh')}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.7.0/conf/server.xml')
              .with_content(/<Connector port="7990"/)
              .with_content(/path=""/)
              .without_content(/proxyName/)
              .without_content(/proxyPort/)
              .without_content(/scheme/)
          end

          it do
            should contain_file('/home/stash/shared/stash-config.properties')
              .with_content(/jdbc\.driver=org\.postgresql\.Driver/)
              .with_content(/jdbc\.url=jdbc:postgresql:\/\/localhost:5432\/stash/)
              .with_content(/jdbc\.user=stash/)
              .with_content(/jdbc\.password=password/)
          end

          it do
            should contain_ini_setting('stash_httpport').with({
              'value' => '7990',
            })
          end
        end

        context 'proxy settings ' do
          let(:params) {{
            :version     => '3.7.0',
            :proxy   => {
              'scheme'    => 'https',
              'proxyName' => 'stash.example.co.za',
              'proxyPort' => '443',
            },
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.7.0/conf/server.xml') \
              .with_content(/proxyName = \'stash\.example\.co\.za\'/)
              .with_content(/proxyPort = \'443\'/)
              .with_content(/scheme = \'https\'/)
          end
        end

        context 'jvm_xms => 1G' do
          let(:params) {{
            :version => '3.7.0',
            :jvm_xms => '1G',
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.7.0/bin/setenv.sh')
              .with_content(/^JVM_MINIMUM_MEMORY="1G"/)
          end
        end

        context 'jvm_xmx => 4G' do
          let(:params) {{
            :version => '3.7.0',
            :jvm_xmx => '4G',
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.7.0/bin/setenv.sh')
              .with_content(/^JVM_MAXIMUM_MEMORY="4G"/)
          end
        end

        context 'jvm_permgen => 384m' do
          let(:params) {{
            :version     => '3.7.0',
            :jvm_permgen => '384m',
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.7.0/bin/setenv.sh')
              .with_content(/^STASH_MAX_PERM_SIZE=384m/)
          end
        end

        context 'java_opts => "-Dhttp.proxyHost=proxy.example.co.za -Dhttp.proxyPort=8080"' do
          let(:params) {{
            :version     => '3.7.0',
            :java_opts   => '-Dhttp.proxyHost=proxy.example.co.za -Dhttp.proxyPort=8080',
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.7.0/bin/setenv.sh')
              .with_content(/JAVA_OPTS="-Dhttp\.proxyHost=proxy\.example\.co\.za -Dhttp\.proxyPort=8080/)
          end
        end

        context 'context_path => "stash"' do
          let(:params) {{
            :version      => '3.7.0',
            :context_path => '/stash',
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.7.0/conf/server.xml')
              .with_content(/path="\/stash"/)
          end
        end

        context 'tomcat_port => "7991"' do
          let(:params) {{
            :version      => '3.7.0',
            :tomcat_port => '7991',
          }}
          it do
            should contain_file('/opt/stash/atlassian-stash-3.7.0/conf/server.xml')
              .with_content(/<Connector port="7991"/)
          end

          it do
            should contain_ini_setting('stash_httpport').with({
              'value' => '7991',
            })
          end
        end
      end
    end
  end
end
end

require 'spec_helper.rb'

describe 'stash' do
describe 'stash::config' do
  context 'proxy params' do
    let(:params) {{
      :javahome => '/opt/java',
      :version  => '3.2.4',
      :proxy    => {
        'scheme'    => 'https',
        'proxyName' => 'stash.example.co.za',
        'proxyPort' => '443',
      },
    }}
    it { should contain_file('/opt/stash/atlassian-stash-3.2.4/bin/setenv.sh') \
       .with_content(/JAVA_HOME=\/opt\/java/)
    }
    it { should contain_file('/opt/stash/atlassian-stash-3.2.4/bin/user.sh')}
    it { should contain_file('/opt/stash/atlassian-stash-3.2.4/conf/server.xml') \
      .with_content(/proxyName = \'stash\.example\.co\.za\'/)
      .with_content(/proxyPort = \'443\'/)
      .with_content(/scheme = \'https\'/)
    }
    it { should contain_file('/home/stash/shared/stash-config.properties')}
  end
end
end

require 'spec_helper.rb'
describe 'stash' do
describe 'stash::facts' do
    regexp_pe = /^#\!\/opt\/puppet\/bin\/ruby$/
    regexp_oss = /^#\!\/usr\/bin\/env ruby$/
    external_fact_file = '/etc/facter/facts.d/stash_facts.rb'

    it { should contain_file(external_fact_file) }

    # Test puppet enterprise shebang generated correctly
    context 'with puppet enterprise' do
        let(:facts) { {:puppetversion => "3.4.3 (Puppet Enterprise 3.2.1)"} }
        it do
          should contain_file(external_fact_file) \
            .with_content(regexp_pe)
        end
    end
    # Test puppet oss shebang generated correctly
    context 'with puppet oss' do
        let(:facts) { {:puppetversion => "all other versions"} }
        it do
          should contain_file(external_fact_file) \
            .with_content(regexp_oss)
        end
    end
end
end

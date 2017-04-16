require 'spec_helper'

describe 'stash::facts', type: :class do
  context 'supported operating systems' do
    let(:pre_condition) { "class{'::stash': javahome => '/opt/java', }" }

    on_supported_os.each do |os, facts|
      context "on #{os} #{facts}" do
        let(:facts) do
          facts
        end

        regexp_pe = %r{^#!/opt/puppet/bin/ruby$}
        regexp_oss = %r{^#!/usr/bin/env ruby$}
        pe_external_fact_file = '/etc/puppetlabs/facter/facts.d/stash_facts.rb'
        external_fact_file = '/etc/facter/facts.d/stash_facts.rb'

        it { is_expected.to contain_file(external_fact_file) }

        # Test puppet enterprise shebang generated correctly
        context 'with puppet enterprise' do
          let(:facts) do
            facts.merge(puppetversion: '3.4.3 (Puppet Enterprise 3.2.1)')
          end

          it do
            is_expected.to contain_file(pe_external_fact_file). \
              with_content(regexp_pe)
          end
        end

        ## Test puppet oss shebang generated correctly
        context 'with puppet oss' do
          it do
            is_expected.to contain_file(external_fact_file). \
              with_content(regexp_oss).
              with_content(%r{7990/rest/api/})
          end
        end

        context 'with context' do
          let(:params) do
            { context_path: '/stash' }
          end

          it do
            is_expected.to contain_file(external_fact_file). \
              with_content(%r{7990/stash/rest/api/})
          end
        end
      end
    end
  end
end

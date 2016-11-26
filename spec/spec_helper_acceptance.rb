require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

unless ENV['RS_PROVISION'] == 'no' || ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    # This will install the latest available package on el and deb based
    # systems fail on windows and osx, and install via gem on other *nixes
    foss_opts = { default_action: 'gem_install' }
    install_puppet(foss_opts)
    install_package(host, 'git')
    on host, "mkdir -p #{host['distmoduledir']}"
    on host, "sed -i '/templatedir/d' #{host['puppetpath']}/puppet.conf"
  end
end

proxy_host = ENV['BEAKER_PACKAGE_PROXY'] || ''
unless proxy_host.empty?
  hosts.each do |host|
    on host, "echo 'export http_proxy='#{proxy_host}'' >> /root/.bashrc"
    on host, "echo 'export https_proxy='#{proxy_host}'' >> /root/.bashrc"
    on host, "echo 'export no_proxy=\"localhost,127.0.0.1,localaddress,.localdomain.com,#{host.name}\"' >> /root/.bashrc"
  end
end

UNSUPPORTED_PLATFORMS = %w(AIX windows Solaris).freeze

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    puppet_module_install(
      source: proj_root,
      module_name: 'stash',
      ignore_list: %w(spec/fixtures/* .git/* .vagrant/*)
    )
    hosts.each do |host|
      on host, "/bin/touch #{default['puppetpath']}/hiera.yaml"
      on host, 'chmod 755 /root'
      if fact('osfamily') == 'Debian'
        on host, "echo \"en_US ISO-8859-1\nen_NG.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\n\" > /etc/locale.gen"
        on host, '/usr/sbin/locale-gen'
        on host, '/usr/sbin/update-locale'
      end
      on host, puppet('module', 'install', 'puppet-archive'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-inifile'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-postgresql'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppet-staging'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), acceptable_exit_codes: [0, 1]
    end
  end
end

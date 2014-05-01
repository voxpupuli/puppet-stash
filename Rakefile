require 'rake'
require 'puppetlabs_spec_helper/rake_tasks'
require 'rspec/core/rake_task'

task :default => :spec

begin
  if Gem::Specification::find_by_name('puppet-lint')
    require 'puppet-lint/tasks/puppet-lint'
    PuppetLint.configuration.send('disable_80chars')
    PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "vendor/**/*.pp"]
    task :default => [:rspec, :lint]
  end
rescue Gem::LoadError
end



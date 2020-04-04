# This file is managed via modulesync
# https://github.com/voxpupuli/modulesync
# https://github.com/voxpupuli/modulesync_config

# puppetlabs_spec_helper will set up coverage if the env variable is set.
# We want to do this if lib exists and it hasn't been explicitly set.
ENV['COVERAGE'] ||= 'yes' if Dir.exist?(File.expand_path('../../lib', __FILE__))

require 'voxpupuli/test/spec_helper'

if File.exist?(File.join(__dir__, 'default_module_facts.yml'))
  facts = YAML.load(File.read(File.join(__dir__, 'default_module_facts.yml')))
  if facts
    facts.each do |name, value|
      add_custom_fact name.to_sym, value
    end
  end
end

STASH_VERSION = '6.8.1'.freeze

BACKUP_VERSION = '3.3.2'.freeze

BITBUCKET_VERSION = '4.0.2'.freeze

BITBUCKET_BACKUP_VERSION = '2.0.0'.freeze

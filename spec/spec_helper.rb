# Require our library
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'egauge'))

RSpec.configure do |config|
  #config.add_formatter 'documentation'
  config.color = true
  config.backtrace_clean_patterns = [/rspec/]
end

# Set up some sample files
SAMPLE_FILE = {}
Dir.glob(File.join(File.dirname(__FILE__), './samples/*.xml')).each do |p|
  SAMPLE_FILE[File.basename(p,'.xml')] = File.read(p)
end
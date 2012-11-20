# Load our dependencies
#require 'iron/extensions'

# Requires all classes
search_path = File.join(File.expand_path(File.dirname(__FILE__)), '*', '*.rb')
Dir.glob(search_path) do |path|
  require path
end

module EGauge
  
  def self.parse_time(str)
    # Chop off the initial hex flagging if present
    str = str[2..-1] if str[/^0x/]
    # Do ruby stuff to convert to 4 byte unsigned int
    as_int = str.hex
    # And return as a time...
    Time.at(as_int).utc
  end
  
end
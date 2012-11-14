require 'nokogiri'

module EGauge
  class Data
    # Attributes
    attr_reader :config_serial, :registers, :timestamp
    
    # Parse XML and return an EGauge::Data object containing the data.
    # This will be the primary entry point for most uses of this gem.
    def self.parse(xml)
      doc = Nokogiri::XML(xml)
      doc.slop!
      
      data = new(doc)
      data
    end
    
    def initialize(xml)
      # Store off Nokogiri xml tree
      @xml = xml
      @config_serial = @xml.group['serial']
      
      # Get first data segment, which sets the register info for all data segments
      data = @xml.group.data
      data = data.first if data.is_a?(Nokogiri::XML::NodeSet)
      
      # Save off our starting timestamp for this whole group
      @timestamp = EGauge::parse_time(data['time_stamp'])
      
      # Build our registers
      index = 0
      @registers = data.cname.collect do |col|
        reg = EGauge::Register.new(self, index, col)
        index += 1
        reg
      end
    end
    
    def xml
      @xml
    end
    
    def num_registers
      @registers.count
    end
    
    def num_rows
      # Sum the count of rows across each <data> node
      @xml.group.elements.collect do |chunk|
        (chunk / './r').count
      end.inject(&:+)
    end
    
    # Run each value in this register
    def each_row
      @xml.group.elements.each do |chunk|
        # Set up for running this data chunk - prep timestamp and increment step from source xml
        ts = EGauge::parse_time(chunk['time_stamp'])
        step = chunk['time_delta'].to_i
        
        # Run each row in the chunk, and yield our results
        (chunk / './r').each do |row|
          vals = (row / './c').collect {|c| c.text.to_i}
          yield ts, vals, step
          ts += step
        end
      end
    end
    
    # Return results as a 2D array, like so: [ [timestamp1, [val1, val2...], seconds1], [timestamp2, [val1, val2,...], seconds2], ... ]
    def to_a
      res = []
      each_row do |ts, vals, step|
        res << [ts, vals, step]
      end
      res
    end
    
  end
end

# Represents a single register in the
module EGauge
  class Register
    
    attr_accessor :index, :label, :type_code
    
    def initialize(data, index, def_node)
      @data = data
      @index = index
      
      @label = def_node.text
      @type_code = def_node['t']
    end
    
    # Run each value in this register, yielding |timestamp, value| for each
    def each_row
      @data.xml.group.elements.each do |chunk|
        # Set up for running this data chunk - prep timestamp and increment step from source xml
        ts = EGauge::parse_time(chunk['time_stamp'])
        step = chunk['time_delta'].to_i
        
        # Run each row in the chunk, and yield our results
        (chunk / './r').each do |row|
          val = (row / './c')[@index].text.to_i
          yield ts, val
          ts += step
        end
      end
    end
    
    # Return results as a 2D array, like so: [ [timestamp1, val1], [timestamp2, val2], ... ]
    def to_a
      res = []
      each_row do |ts, val|
        res << [ts, val]
      end
      res
    end
    
    def count
      @data.num_rows
    end
    
  end
end
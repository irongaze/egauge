
describe EGauge::Data do
  
  before do
    # Let's get us a sample to work on...
    @data1 = EGauge::Data.parse(SAMPLE_FILE['data1'])
  end
  
  it 'should parse valid xml' do
    xml = SAMPLE_FILE['data1']
    group = EGauge::Data.parse(xml)
    group.should_not be_nil
  end
  
  it 'should provide the serial number' do
    @data1.serial.should == '0x37cdd096'
  end
  
  it 'should provide the timestamp' do
    @data1.timestamp.should == Time.at(0x4c9197e4)
  end
  
  it 'should provide a count of the registers' do
    @data1.num_registers.should == 3
  end

  it 'should let you access registers as an array' do
    @data1.should respond_to(:registers)
    @data1.registers.should be_a(Array)
    @data1.registers[2].should be_a(EGauge::Register)
  end

  it 'should know the number of data rows' do
    @data1.num_rows.should == 3
  end
  
  it 'should allow access to full row data' do
    @data1.each_with_timestamp do |ts, values|
      ts.should be_a(Time)
      values.should be_a(Array)
      values.count.should == 3
    end
  end

end
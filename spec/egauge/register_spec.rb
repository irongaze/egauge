
describe EGauge::Register do
  
  before do
    @data1 = EGauge::Data.parse(SAMPLE_FILE['data1'])
    @reg = @data1.registers[1]
  end
  
  it 'should provide a label' do
    @reg.label.should == 'Solar'
  end
  
  it 'should provide a type code' do
    @reg.type_code.should == 'P'
  end
  
  it 'should know its own index' do
    @reg.index.should == 1
  end
  
  it 'should return valid values' do
    @reg.to_a.collect {|row| row[1]}.should == [21308125431, 21308125526, 21308125626]
  end
  
  it 'should allow iterating over values with timestamps' do
    counter = 0
    @reg.each_with_timestamp do |ts, val|
      val.should be_a(Integer)
      ts.should be_a(Time)
      counter += 1
    end
    counter.should == 3
  end
  
  it 'should know the number of values it owns' do
    @reg.count
  end
  
end
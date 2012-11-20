
describe EGauge do
  
  it 'should parse times correctly' do
    EGauge.parse_time('0x4c9197e4').should == Time.at(1284610020).utc
  end
  
end
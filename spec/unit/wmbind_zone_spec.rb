require File.join(File.dirname(__FILE__), '../spec_helper')

describe WMBIND::Zone do

  before do
    @zone = WMBIND::Zone.new(File.join(File.dirname(__FILE__), '../data/test.com'))
  end

  it "should parse global TTL" do
    @zone.ttl.should == 604800
  end
  
  it "should parse SOA" do
    soa = @zone.soa

    soa.mname.to_s.should == 'ns1.test.com'
    soa.rname.to_s.should == 'admin.test.com'
    
    soa.ttl.should == 604800
    soa.serial.should == 2011031600
    soa.refresh.should == 28800
    soa.retry.should == 7200
    soa.expire.should == 1209600
    soa.minimum.should == 604800
  end

  it "should parse NS records" do
    
  end
end


require File.join(File.dirname(__FILE__), '../spec_helper')

describe WMBIND::Zone do


  describe "parsing constants and SOA" do
    before do
      @zone = WMBIND::Zone.new(File.join(File.dirname(__FILE__),
                                         '../data/test.com'))
    end

    it "should parse name from ORIGIN" do
      @zone.name.should == 'test.com.'
    end

    it "should parse name from filename" do
      @zone = WMBIND::Zone.new(File.join(File.dirname(__FILE__),
                                         '../data/test.com-without-origin'))

      @zone.name.should == 'test.com-without-origin'
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
  end

  describe "parsing records" do
    before do
      @records = WMBIND::Zone.new(File.join(File.dirname(__FILE__),
                                            '../data/test.com')).records
    end
    
    it "should parse NS records" do
      # First and seconds is NS
      @records[0][:type].should == 'NS'
      @records[0][:name].should == '@'
      @records[0][:domain].should == 'ns1.test.com.'
    end

    it "should parse A records" do
      @records[2][:type].should == 'A'
      @records[2][:name].should == '@'
      @records[2][:address].should == '127.0.0.1'
    end

    it "should parse MX records" do
      @records[3][:type].should == 'MX'
      @records[3][:name].should == '@'
      @records[3][:exchange].should == 'mail.test.com.'
      @records[3][:preference].should == 10
    end
  end
end


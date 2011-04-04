require File.join(File.dirname(__FILE__), '../spec_helper')

describe "WMBINDClient" do

  def app
    WMBINDClient.new
  end
  
  it "displays server info" do
    get '/'
    last_response.should be_ok
    last_response.headers['Content-Type'].should include('application/json')

    resp = JSON.parse(last_response.body)
    
    keys = ['hostname', 'uname', 'bind']
    keys.each do |key|
      resp.keys.should include(key)
    end

    resp['hostname'].should == WMBIND::Server.hostname
    resp['uname'].should == WMBIND::Server.uname
    resp['bind'].should == WMBIND::Server.bind
  end

  context "zone" do

    before do
      get '/zone/test.com'
      last_response.should be_ok
      last_response.headers['Content-Type'].should include('application/json')

      @resp = JSON.parse(last_response.body)
    end
    
    it "displays info" do
      keys = ['name', 'ttl', 'soa']
      @resp.keys.should == keys
      
    end

    it "displays name" do
      zone = WMBIND::Zone.new(File.join(File.dirname(__FILE__),
                                        '../data/test.com'))
      @resp['name'].should == zone.name
    end

    it "displays ttl" do
      zone = WMBIND::Zone.new(File.join(File.dirname(__FILE__),
                                        '../data/test.com'))
      @resp['ttl'].should == zone.ttl
    end

    it "displays soa" do
      @zsoa = WMBIND::Zone.new(File.join(File.dirname(__FILE__),
                                         '../data/test.com')).soa
      @soa = @resp['soa']
      @soa.should == { 'ttl' => @zsoa.ttl, 'serial' => @zsoa.serial,
        'refresh' => @zsoa.refresh, 'retry' => @zsoa.retry,
        'expire' => @zsoa.expire, 'minimum' => @zsoa.minimum,
        'ns' => @zsoa.mname.to_s + '.', 'email' => @zsoa.rname.to_s + '.' }
    end
  end

  context "records" do
    before do
      get '/zone/test.com/records'
      last_response.should be_ok
      last_response.headers['Content-Type'].should include('application/json')

      @resp = JSON.parse(last_response.body)
    end

    it "should display NS records" do
      # The first and second record will be the NS record in test.com zone
      
      @resp[0]['type'].should == 'NS'
      @resp[0]['name'].should == '@'
      @resp[0]['domain'].should == 'ns1.test.com.'

      @resp[1]['type'].should == 'NS'
      @resp[1]['name'].should == '@'
      @resp[1]['domain'].should == 'ns2.test.com.'
    end

    it "should display A record" do
      @resp[2]['type'].should == 'A'
      @resp[2]['name'].should == '@'
      @resp[2]['address'].should == '127.0.0.1'
    end

    it "should display MX record" do
      @resp[3]['type'].should == 'MX'
      @resp[3]['name'].should == '@'
      @resp[3]['exchange'].should == 'mail.test.com.'
      @resp[3]['preference'].should == 10
    end
  end
end

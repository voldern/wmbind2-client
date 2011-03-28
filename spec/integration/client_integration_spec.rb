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
    resp.keys.should == keys

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
      zone = WMBIND::Zone.new(File.join(File.dirname(__FILE__), '../data/test.com'))
      @resp['name'].should == zone.name
    end

    it "displays ttl" do
      zone = WMBIND::Zone.new(File.join(File.dirname(__FILE__), '../data/test.com'))
      @resp['ttl'].should == zone.ttl
    end

    it "displays soa" do
      @zsoa = WMBIND::Zone.new(File.join(File.dirname(__FILE__), '../data/test.com')).soa
      @soa = @resp['soa']
      @soa.should == { 'ttl' => @zsoa.ttl, 'serial' => @zsoa.serial,
        'refresh' => @zsoa.refresh, 'retry' => @zsoa.retry,
        'expire' => @zsoa.expire, 'minimum' => @zsoa.minimum,
        'ns' => @zsoa.mname.to_s + '.', 'email' => @zsoa.rname.to_s + '.' }
    end
  end
end

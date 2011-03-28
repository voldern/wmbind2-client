require File.join(File.dirname(__FILE__), '../spec_helper')

describe WMBIND::Server do
  
  it "should provide hostname" do
    Uname.should_receive(:nodename).and_return('localhost')
    WMBIND::Server.hostname.should == 'localhost'
  end

  it "should provide uname" do
    IO.should_receive(:popen).with('uname -a').and_return('Linux hostname 2.6.37-ARCH #1 SMP PREEMPT Tue Mar 15 09:21:17')
    WMBIND::Server.uname.should == 'Linux hostname 2.6.37-ARCH #1 SMP PREEMPT Tue Mar 15 09:21:17'
  end
  
  it "should provide BIND version" do
    IO.should_receive(:popen).with('named -v').and_return('BIND 9.0.0')
    WMBIND::Server.bind.should == 'BIND 9.0.0'
  end
end

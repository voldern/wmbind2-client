require 'sys/uname'
include Sys

module WMBIND
  class Server
    def self.hostname
      Uname.nodename
    end

    def self.uname
      IO.popen('uname -a') { |f| f.gets }.strip
    end

    def self.bind
      IO.popen('named -v') { |f| f.gets }.strip
    end
  end
end

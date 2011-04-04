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
      version = IO.popen('named -v') { |f| f.gets }
      unless version.nil?
        version.strip
      else
        'not found'
      end
    end
  end
end

require 'dnsruby'

module WMBIND
  class Zone

    attr_reader :soa, :ttl
    
    def initialize(zone_file)
      @zone = File.new(zone_file, 'r')
      @records = []
      @ttl = nil
      
      @soa = parse_soa
      @records = parse_records
    end

    private

    def parse_soa
      # Read untill the first ')', that denotes the end of the SOA
      # part of the zonefile
      soa = []
      while line = @zone.gets
        # Ignore TTL line
        if line =~ /^\$TTL\s+(\d+)/
          @ttl = $1.to_i
          next
        end
        
        # Remove comments from file
        if line.include?(';')
          line = line[0...(line.index(';'))]
        end
        
        soa << line
        break if line.include?(')')
      end

      # Check if this is a valid SOA record
      soa = soa.join("\n")
      if soa =~ /^([\w\d\.-]+|@)\s+(\d*)\s*IN\s+SOA\s+([\w\d\.-]+)\s+([\w\d\.-]+)\s+\(\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\)/
        Dnsruby::RR.create(soa)
      else
        false
      end
    end

    def parse_records
      while line = @zone.gets
        # Do not parse line containing only a comment
        next if line =~ /^\s*;\s*$/
        @records << Dnsruby::RR.create(line)
      end
      @records
    end
  end
end

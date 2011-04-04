require 'dnsruby'

module WMBIND
  class Zone

    attr_reader :soa, :ttl, :records
    
    def initialize(zone_file)
      @zone = File.new(zone_file, 'r')
      @records = []
      @ttl = nil
      @name = nil
      
      @soa = parse_soa
      @records = parse_records
    end

    def name
      if @name.nil?
        # Parse name from filename
        @name = File.basename(@zone.path)
      else
        @name
      end
    end

    private

    def parse_soa
      # Read untill the first ')', that denotes the end of the SOA
      # part of the zonefile
      soa = []
      while line = @zone.gets
        # Ignore origin line
        if line =~ /^\$ORIGIN\s+([\w\d\.-]+)/
          @name = $1
          next
        end
        
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
      rrecords = []
      while line = @zone.gets
        # Do not parse line containing only a comment
        next if line =~ /^\s*;\s*$/
        rrecords << Dnsruby::RR.create(line)
      end

      rrecords.each do |r|
        record = { :string => r.to_s, :ttl => r.ttl, :type => r.type }
        
        # If its an catch all record remove \\ from name
        if Dnsruby::Name::create('@') == r.name
          record[:name] = '@'
        else
          record[:name] = r.name.to_s
        end
        
        if r.class == Dnsruby::RR::IN::NS
          record[:domain] = domain_to_s(r.domainname)
        elsif r.class == Dnsruby::RR::IN::A
          record[:address] = r.address.to_s
        elsif r.class == Dnsruby::RR::IN::MX
          record.update({ :exchange => domain_to_s(r.exchange),
                        :preference => r.preference })
        end

        records << record
      end

      records
    end

    private
    def domain_to_s(path)
      if path.absolute?
        path.to_s + '.'
      else
        path.to_s
      end
    end
  end
end

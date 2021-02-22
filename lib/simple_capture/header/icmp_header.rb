module SimpleCapture
  class ICMPHeader
    attr_reader :type, :code, :checksum, :id, :seq_number, :data

    # @param [Array<Integer>] [10, 46, ...]
    def initialize(bytes: nil)
      convert_bytes_to_header(bytes) unless bytes.nil?
    end

    def dump
      puts "■icmp--------------------------------------".blue
      print_checksum
      print_code
      print_type
      print_id
      print_seqnumber
      print_data
    end

    private

    def print_checksum
      puts "checksum = 0x#{combine_2bits_in_hex(checksum).to_s(16)}"
    end

    def print_code
      puts "code = #{code}"
    end

    def print_data
      puts "data = "
      data.each_slice(10) do |data10|
        data10.each { |data_| print "0x#{data_.to_s(16)} " }
        puts "\n"
      end
    end

    def print_id
      if id
        puts "id = 0x#{combine_2bits_in_hex(id).to_s(16)}"
      end
    end

    def print_seqnumber
      if seq_number
        puts "seq_number = 0x#{combine_2bits_in_hex(seq_number).to_s(16)}"
      end
    end

    def print_type
      puts "type = #{type}"
    end

    # Combine 2 bits of numbers in hexadecimal
    #
    # @param [Array<Integer>] [0d80, 0d30]
    # @return [Integer] 0x501e... 0d80 -> 0x50, 0d30 -> 0x1e
    def combine_2bits_in_hex(bytes)
      (bytes[0].to_s(16) + bytes[1].to_s(16)).to_i(16)
    end

    def convert_bytes_to_header(bytes)
      @type = bytes[0]
      @code = bytes[1]
      @checksum = bytes[2..3]

      if @type == 0 || 8
        @id = bytes[4..5]
        @seq_number = bytes[6..7]
        @data = bytes[8..(bytes.size-1)]
      else
        @data = bytes[4..(bytes.size-1)]
      end
    end
  end
end

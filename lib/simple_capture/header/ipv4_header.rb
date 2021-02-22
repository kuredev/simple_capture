module SimpleCapture
  class IPv4Header
    ICMP = 1

    attr_reader :version, :ihl, :type_of_service, :length, :id, :flags, :offset, :ttl,
                :checksum, :src_addr, :dst_addr, :protocol

    # @param [Array<Integer>] 各バイトの数値の配列、[10, 46, ...]
    def initialize(bytes: nil)
      # support 20Byte IPHeader only now.
      raise ArgumentError, "bytes's size must be 20Byte" unless bytes.size == 20

      convert_bytes_to_header(bytes) unless bytes.nil?
    end

    def dump
      puts "■ipv4--------------------------------------".yellow
      print_version
      print_ihl
      print_type_of_service
      print_length
      print_id
      print_flags
      print_offset
      print_ttl
      print_protocol
      print_checksum
      print_src_addr
      print_dst_addr
    end

    def upper_layer_protocol_icmp?
      protocol == ICMP
    end

    private

    # Combine 2 bits of numbers in hexadecimal
    #
    # @param [Array<Integer>] [0d80, 0d30]
    # @return [Integer] 0x501e... 0d80 -> 0x50, 0d30 -> 0x1e
    def combine_2bits_in_hex(bytes)
      bytes_hex = bytes.map { |byte| byte.to_s(16).rjust(2, "0") }
      bytes_hex.join.to_i(16)

      # (bytes[0].to_s(16) + bytes[1].to_s(16)).to_i(16)
    end

    def convert_bytes_to_header(bytes)
      @version = bytes[0][4, 4]
      @ihl = bytes[0][0, 4]
      @type_of_service = bytes[1]
      @length = bytes[2..3]
      @id = bytes[4..5]
      bytes67 = combine_2bits_in_hex(bytes[6..7])
      @flags = bytes67[0, 3]
      @offset = bytes67[3, 13]
      @ttl = bytes[8]
      @protocol = bytes[9]
      @checksum = bytes[10..11]
      @src_addr = bytes[12..15]
      @dst_addr = bytes[16..19]
    end

    def print_checksum
      puts "checksum = 0x#{combine_2bits_in_hex(checksum).to_s(16)}"
    end

    def print_dst_addr
      puts "dst_addr = #{dst_addr}"
    end

    def print_flags
      puts "flags = #{flags}"
    end

    def print_id
      puts "id = 0x#{combine_2bits_in_hex(id).to_s(16)}\n"
    end

    def print_ihl
      puts "ihl = #{ihl}"
    end

    def print_length
      puts "length = 0x#{combine_2bits_in_hex(length).to_s(16)}"
    end

    def print_offset
      puts "offset = #{offset}"
    end

    def print_protocol
      if protocol == ICMP
        puts "protocol = ICMP"
      else
        puts "protocol = [UnKnown Protocol]"
      end
    end

    def print_src_addr
      puts "src_addr = #{src_addr}"
    end

    def print_type_of_service
      puts "type_of_service = #{type_of_service}"
    end

    def print_ttl
      puts "ttl = #{ttl}"
    end

    def print_version
      puts "version = #{version}"
    end
  end
end

module SimpleCapture
  class EtherHeader
    IPv4 = 0x0800

    attr_reader :dst_mac_address, :src_mac_address, :type

    # @param [Array<Integer>] [10, 46, ...]
    def initialize(bytes: nil)
      # support 14Byte EhterHeader only now.
      raise ArgumentError, "bytes's size must be 10Byte" unless bytes.size == 14

      convert_bytes_to_headers(bytes) unless bytes.nil?
    end

    # @return [Boolean]
    def upper_layer_protocol_ipv4?
      type_hex = type.map { |byte| byte.to_s(16).rjust(2, "0") }
      type_hex.join.to_i(16) == IPv4
    end

    # Print Header Info
    def dump
      puts "■ether header------------------------------".red
      print_dst_mac_address
      print_src_mac_address
      print_type
    end

    private

    def convert_bytes_to_headers(bytes)
      @dst_mac_address = bytes[0..5]
      @src_mac_address = bytes[6..11]
      @type = bytes[12..13]
    end

    def print_dst_mac_address
      hex_dst_mac_address = dst_mac_address.map { |byte| byte.to_s(16) }

      puts "dst_mac_address = #{hex_dst_mac_address[0]}:\
#{hex_dst_mac_address[1]}:\
#{hex_dst_mac_address[2]}:\
#{hex_dst_mac_address[3]}:\
#{hex_dst_mac_address[4]}:\
#{hex_dst_mac_address[5]}"
    end

    def print_src_mac_address
      hex_src_mac_address = src_mac_address.map { |byte| byte.to_s(16) }

      puts "src_mac_address = #{hex_src_mac_address[0]}:\
#{hex_src_mac_address[1]}:\
#{hex_src_mac_address[2]}:\
#{hex_src_mac_address[3]}:\
#{hex_src_mac_address[4]}:\
#{hex_src_mac_address[5]}"
    end

    def print_type
      type_hex = type.map { |byte| byte.to_s(16).rjust(2, "0") }
      type_hex_int = type_hex.join.to_i(16) # ["08", "00"]
      protocol_display = if type_hex_int == IPv4
                           "IPv4"
                         else
                           "[UnKnown Protocol]"
                         end
      puts "protocol = #{protocol_display}"
    end
  end
end

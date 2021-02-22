module SimpleCapture
  class RecvMessageHandler
    def initialize(mesg)
      @mesg = mesg
    end

    # @return [Packet]
    def to_packet
      headers = []
      ether = SimpleCapture::EtherHeader.new(bytes: @mesg.bytes[0..13])
      headers.push(ether)

      if ether.upper_layer_protocol_ipv4?
        ip = SimpleCapture::IPv4Header.new(bytes: @mesg.bytes[14..33])
        headers.push(ip)
        if ip.upper_layer_protocol_icmp?
          icmp =  SimpleCapture::ICMPHeader.new(bytes: @mesg.bytes[34..(@mesg.bytes.size-1)])
          headers.push(icmp)
        end
      end
      SimpleCapture::Packet.new(headers)
    end
  end
end


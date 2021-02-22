require "socket"

module SimpleCapture
  class Capture
    SOL_PACKET            = 0x0107 # bits/socket.h
    IFINDEX_SIZE          = 0x0004 # sizeof(ifreq.ifr_ifindex) on 64bit
    IFREQ_SIZE            = 0x0028 # sizeof(ifreq) on 64bit
    SIOCGIFINDEX          = 0x8933 # bits/ioctls.h
    PACKET_MR_PROMISC     = 0x0001 # netpacket/packet.h
    PACKET_MREQ_SIZE      = 0x0010 # sizeof(packet_mreq) on 64bit
    PACKET_ADD_MEMBERSHIP = 0x0001 # netpacket/packet.h
    ETH_P_ALL             = 768    # htons(ETH_P_ALL), linux/if_ether.h

    # @param [String] interface_name
    def initialize(interface_name)
      @interface_name = interface_name
    end

    # Run Capture
    def run
      socket = generate_socket(@interface_name)
      cap_loop(socket)
    end

    private

    def cap_loop(socket)
      while true
        mesg, _ = socket.recvfrom(1500)
        packet = RecvMessageHandler.new(mesg).to_packet
        packet.dump
      end
    end

    def bind_if(socket, interface_name)
      index_str = mr_ifindex(interface_name)

      eth_p_all_hbo = [ ETH_P_ALL ].pack('S').unpack('S>').first
      sll = [ Socket::AF_PACKET, eth_p_all_hbo, index_str ].pack('SS>a16')
      socket.bind(sll)
    end

    # @return [Integer]
    def if_name_to_index(if_name)
      Socket.getifaddrs.find do |ifaddr|
        ifaddr.name == if_name
      end&.ifindex
    end

    def generate_socket(interface_name)
      socket = Socket.new(Socket::AF_PACKET, Socket::SOCK_RAW, ETH_P_ALL)
      bind_if(socket, interface_name)
      socket_promiscuous(socket, interface_name)
      socket
    end

    def mr_ifindex(if_name)
      [[if_name_to_index(if_name)].pack("c")].pack("a4")
    end

    def mr_type
      [PACKET_MR_PROMISC].pack("S")
    end

    def mr_alen
      [0].pack("S")
    end

    def mr_address
      [0].pack("C")*8
    end

    #
    # https://linuxjm.osdn.jp/html/LDP_man-pages/man7/packet.7.html
    # struct packet_mreq {
    #  int            mr_ifindex; 4Byte
    #  unsigned short mr_type; 2Byte
    #  unsigned short mr_alen; 2Byte
    #  unsigned char  mr_address[8]; 1Byte * 8
    #};
    #
    # @param [String]
    # @return [String]
    def mreq(interface)
      mr_ifindex(interface) + mr_type + mr_alen + mr_address
    end

    def socket_promiscuous(socket, interface_name)
      socket.setsockopt(SOL_PACKET, PACKET_ADD_MEMBERSHIP, mreq(interface_name))
    end
  end
end

module SimpleCapture
  class Packet

    # @param [Array] headers
    def initialize(headers)
      @headers = headers
    end

    def dump
      puts "\n■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■".green
      puts "Display Packet".green
      puts "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■".green
      @headers.each do |header|
        header.dump
      end
    end
  end
end

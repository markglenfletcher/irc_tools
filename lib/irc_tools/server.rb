module IrcTools
  class Server
    attr_reader :server, :port, :connected, :socket

    def initialize(server_name, port_number)
      @server = server_name
      @port = port_number
      @connected = false
    end

    alias :is_connected? :connected

    def connect
      begin
        @socket = TCPSocket.new(server, port)
        @connected = true
      rescue Exception
        @socket = nil
        @connected = false
      end
    end

    def read
      verify_connection
      begin
        socket.gets.chomp
      rescue Exception
        nil
      end
    end

    def write(message)
      verify_connection
      begin
        socket.puts(message.to_s)
        true
      rescue Exception
        false
      end
    end

    def disconnect
      socket.close
      @connected = false
    end

    private

    def verify_connection
      raise NotConnectedException unless is_connected?
    end

    class NotConnectedException < Exception
      def message
        'Must be connected before this operation is carried out'
      end
    end
  end
end
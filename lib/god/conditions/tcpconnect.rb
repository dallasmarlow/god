module God
  module Conditions
    class Tcpconnect < PollCondition
      attr_accessor :port,
                    :host,
                    :timeout
      def initialize
        super
        require 'socket'
        require 'timeout'
        self.host = '0.0.0.0'
        self.timeout = 1.second
      end

      def valid?
        valid = true
        valid &= complain("Attribute 'port' must be specified", self) if self.port.nil?
        valid
      end

      def test
        begin
          Timeout::timeout(self.timeout) do
            begin
              TCPSocket.new(self.host, self.port).close
              return false
            rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            end
          end
        rescue Timeout::Error
        end
        return true
      end

    end
  end
end

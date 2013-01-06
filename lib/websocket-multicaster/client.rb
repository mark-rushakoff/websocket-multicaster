require 'faye/websocket'
require 'eventmachine'

module WebsocketMulticaster
  class Client
    def initialize(host, port)
      @host = host
      @port = port
    end

    def connect
      EventMachine.run {
        @ws = Faye::WebSocket::Client.new("ws://#{@host}:#{@port}/")

        ws.onopen = lambda do |event|
          # nothing?
        end

        ws.onmessage = lambda do |event|
          received(event.data)
        end

        ws.onclose = lambda do |event|
          disconnected(event.code, event.reason)
          @ws = nil
        end
      }
    end

    def received(message)
      raise 'Consumers of this library should subclass Client and override received'
    end

    def disconnected(code, reason)
      # Nothing for now.  Consumer can optionally override.
    end

    def send(message)
      raise 'Cannot send before connecting' unless @ws
      @ws.send(message)
    end

    def disconnect(code=nil, reason=nil)
      @ws.close(code, reason)
    end
  end
end
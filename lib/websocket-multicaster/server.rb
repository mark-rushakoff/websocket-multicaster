require 'rack'
require 'faye/websocket'
require 'eventmachine'

module WebsocketMulticaster
  class Server
    def initialize
      @channel = EventMachine::Channel.new
      @static = Rack::File.new(File.dirname(__FILE__))
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env)
        subscription_id = @channel.subscribe do |message|
          ws.send message
        end

        ws.onmessage = lambda do |event|
          @channel.push event.data
        end

        ws.onclose = lambda do |event|
          @channel.unsubscribe(subscription_id)
        end

        ws.rack_response
      else
        @static.call(env)
      end
    end
  end
end
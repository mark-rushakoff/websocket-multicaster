require 'rack'
TEST_SERVER_PORT = 57018 # arbitrary port for server in specs

def with_server
  begin
    server_thread = Thread.new do
       Rack::Handler::Thin.run WebsocketMulticaster::Server.new, :Port => TEST_SERVER_PORT
    end
    sleep(1) # server warmup time :(
    yield
  ensure
    server_thread.kill
  end
end

def get_client
  WebsocketMulticaster::Client.new('127.0.0.1', TEST_SERVER_PORT)
end
require 'spec_helper'

describe 'a single client' do
  it 'receives the same messages it sends' do
    with_server do
      client = get_client

      client.should_receive(:received).with('hi from client').once

      client.send('hi from client')
    end
  end
end
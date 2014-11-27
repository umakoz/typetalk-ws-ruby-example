require 'typetalk'
require 'faye/websocket'
require 'eventmachine'

# You can also specify these values via ENV.
# export TYPETALK_CLIENT_ID='...'
# export TYPETALK_CLIENT_SECRET='...'


EM.run {
  access_token = Typetalk::Api.new.get_access_token(scope: 'topic.read').access_token
  
  url = 'https://typetalk.in/api/v1/streaming'
  options = {
             headers: {
                       'Authorization' => "Bearer #{access_token}"
                      }
            }
  ws = Faye::WebSocket::Client.new(url, nil, options)

  ws.on :open do |event|
    p [:open, ws.headers]
  end

  ws.on :message do |event|
    p [:message, event.data]

    # parse body
    # body = Hashie::Mash.new(JSON.parse(event.data))
    # p body.data.post.message
  end

  ws.on :error do |event|
    p [:error, event.message]
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
    EM.stop
  end
}

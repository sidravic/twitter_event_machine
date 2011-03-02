require 'rubygems'
require 'eventmachine'
require 'socket'
require 'json'
require 'hashie'
require File.expand_path("twitter_lib.rb", __FILE__ + "/..")
require File.expand_path("tweet_Fetcher.rb", __FILE__ + "/..")

class Echo < EM::Connection

attr_reader :data, :response, :status, :fetcher  
 def post_init   
   @status = :inactive 
    ip, port = Socket.unpack_sockaddr_in( get_peername) #peer.methods.inspect
    puts  "Connection Established from #{ip} #{port}"
  end

  def receive_data(data)
    puts "[LOGGING: RECEIVED] #{data}"
    @data = JSON.parse(data)
    puts "[LOGGING: PARSED DATA ] #{@data} #{@data.class.to_s}"
    initialize_fetcher
    execute_request
  end

  def unbind
    puts "Connection Lost" + self.inspect
  end
  
  def respond
    send_data(@response)
  end
  
  def execute_request
    if @data["op"] == "fetch"
      puts "Please wait while we fetch the data ..."
      @status = :active
      response = @fetcher.fetch
      puts "[LOGGING FETCHER RESPONSE JSON] " + response.to_json
      send_data(response.to_json)
    end
  end
  
  private

  def initialize_fetcher
    @fetcher =  Fetcher.new({ :consumer_key => "ZfUjxwKPBnOts1BXF664g",
                     :consumer_secret => "U5eQDspHulRH3vBgdJY1VtyhKQcwQnEsocjVq1BFA",
                     :oauth_token => "18478038-Al8rapWg1wFiDE3gIbm58NHnkiw291vX3u0fE1aBG",
                     :oauth_token_secret => "ScaNHDrGIouogq4aZiDZfSuD84OXvW4hiWowhJs9h8" 
                    })
                    
    puts "[LOGGING FETCHER INITIALIZED] #{@fetcher.inspect}"                
  end
  
end

  EM.run do 
    puts "Starting echo server . . . ."
    EM.start_server('0.0.0.0', 6789, Echo)
    puts "STARTED "
  end



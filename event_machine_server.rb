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
#    puts "[LOGGING: RECEIVED] #{data}"
    @data = JSON.parse(data)
#    puts "[LOGGING: PARSED DATA ] #{@data} #{@data.class.to_s}"
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
      send_data(response.to_json)
      Echo.activate_periodic_timer(self)
    elsif @data["op"] == "update"
      puts "Fetching update . . ."
      response = @fetcher.fetch_update
      send_data(response.to_json)      
    end
  end
  
  def self.activate_event_machine(this = nil)
    EM.run do 
        puts "Starting echo server . . . ."
        EM.start_server('0.0.0.0', 6789, Echo)
        puts "STARTED "
    end    
  end
  
  def self.activate_periodic_timer(this = nil)
    EM.add_periodic_timer(5) do
      this.update_operation
      this.execute_request
    end    
  end
  
  def update_operation
    @data["op"] = "update"
  end
  
  private  

  def initialize_fetcher
    @fetcher =  Fetcher.new({
        :consumer_key => "Twitter Consumer Key",
        :consumer_secret => "Twitter Consumer Secret",
        :oauth_token => "Twitter Access Token",
        :oauth_token_secret => "Twitter Access Secret"
        })
                    
   # puts "[LOGGING FETCHER INITIALIZED] #{@fetcher.inspect}"                
  end
  
end

Echo.activate_event_machine

=begin
  EM.run do 
      puts "Starting echo server . . . ."
      EM.start_server('0.0.0.0', 6789, Echo)
      puts "STARTED "
    
      EM.add_periodic_timer(5) do
        puts "Timer activated"
      end    
  end
=end



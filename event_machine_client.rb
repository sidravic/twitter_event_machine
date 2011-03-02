require 'rubygems'
require 'eventmachine'
require 'json'
require File.expand_path("twitter_lib.rb", __FILE__ + "/..")
require File.expand_path("tweet_fetcher.rb", __FILE__ + "/..")
require 'active_support'
require 'active_support/core_ext'
require 'hashie'


module HttpHeaders 
  def post_init    
    msg = {:op => :fetch }.to_json
    send_data(msg) 
    @data = ""    
  end
  
  def receive_data(data)    
    puts "DATA RECIEVED " + data.class.to_s
    puts "DATA RECIEVED " + data.inspect    
    @data = JSON.parse(data)
    puts "[LOGGING RESPONSE FROM SERVER] " + @data.inspect + " #{@data.class.to_s}"
    
    initialize_fetcher
    @fetcher.display_tweets(@data)
  end
  
  def unbind
    if @data =~ /[\n][\r]*[\n]/m
      puts "*********** DATA #{@data} **************"
    end  
    EventMachine::stop_event_loop
  end
  
  private
  
  def initialize_fetcher
     @fetcher =  Fetcher.new({ :consumer_key => "ZfUjxwKPBnOts1BXF664g",
                       :consumer_secret => "U5eQDspHulRH3vBgdJY1VtyhKQcwQnEsocjVq1BFA",
                       :oauth_token => "18478038-Al8rapWg1wFiDE3gIbm58NHnkiw291vX3u0fE1aBG",
                       :oauth_token_secret => "ScaNHDrGIouogq4aZiDZfSuD84OXvW4hiWowhJs9h8" 
                      })
                      
                      
  end
end

EventMachine::run do
  begin
    EventMachine::connect '0.0.0.0', 6789, HttpHeaders
  rescue => e
    puts "#{e.message}"
  end
end


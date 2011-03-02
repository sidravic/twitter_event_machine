require File.expand_path("twitter_lib.rb", __FILE__ + "/..")
require 'active_support'
require 'active_support/core_ext'

class Fetcher
  attr_reader :twitter_lib, :last_tweet_id, :last_fetch_time, :time_line, :twitter_feed

  def initialize(twitter_library_configuration = {})
    @twitter_lib = TwitterLib::Base.new(twitter_library_configuration)    
  end
  
  # expects to know if home_time_line/ public_time_line needs to be fetched
  # used for the initial fetch
  def fetch(opts = {:timeline => :home, :count => 20})    
    if opts[:timeline] == :home    
      opts.delete(:timeline)
      @time_line = @twitter_lib.home_timeline(opts)
    elsif opts[:timeline] == :public
      opts.delete(:timeline)
      @time_line = @twitter_lib.public_timeline(opts)
    end    

    update_timeline_stats unless @time_line.empty? 
    parse_useful_data
    #display_tweets    
    
    @twitter_feed
  end  
  
  def update_timeline_stats
    @last_tweet_id = @time_line.first.id 
    @last_fetch_time = Time.now.to_i
  end
  
  def fetch_update
    puts " ************** LAST TWEET ID **************" + @last_tweet_id.to_s
    fetch({:timeline => :home, :since_id => @last_tweet_id, :count => 20 }) if time_for_next_check?
    
  end
  
  # this could be separated into an independent module
  def display_tweets(_feed_data = [])
    feed_data = _feed_data.empty? ? @twitter_feed : _feed_data    

   if feed_data.instance_of? Array
     feed_data.each do |tweet|
       puts "#{tweet['screen_name']} : #{tweet['text']} \n\r"  
     end
   end
  end
  
  def parse_useful_data
    @twitter_feed = []
    @time_line.each do |tweet|
      @twitter_feed << { 'screen_name' => tweet.user.screen_name, 'text' => tweet.text }
    end
    @twitter_feed    
  end
  
  
  
  private
  
  def time_for_next_check?
   # ((((Time.now) - Time.at(@last_fetch_time))/60) > 2) ? true : false
   true
  end 
  
end


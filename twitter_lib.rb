require 'twitter'
require 'oauth'

module TwitterLib
  ACCESS_TOKEN = '18478038-Al8rapWg1wFiDE3gIbm58NHnkiw291vX3u0fE1aBG'
  ACCESS_SECRET = 'ScaNHDrGIouogq4aZiDZfSuD84OXvW4hiWowhJs9h8'
  
  module TimeLine
     # Returns the 20 most recent statuses, including retweets if they exist, posted by the authenticating user and the users they follow
      #
      # @note This method is identical to {Twitter::Client::Timeline#friends_timeline}, except that this method always includes retweets.
      # @note This method can only return up to 800 statuses, including retweets.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/statuses/home_timeline
      # @example Return the 20 most recent statuses, including retweets if they exist, posted by the authenticating user and the users they follow
      #   Twitter.home_timeline
      def home_timeline(opts = {})
        @client.home_timeline(opts)
      end

      # Returns the 20 most recent statuses posted by the authenticating user and the users they follow
      #
      # @note This method is identical to {Twitter::Client::Timeline#home_timeline}, except that this method will only include retweets if the :include_rts option is set.
      # @note This method can only return up to 800 statuses. If the :include_rts option is set, only 800 statuses, including retweets if they exist, can be returned.
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_rts The timeline will contain native retweets (if they exist) in addition to the standard stream of tweets when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/statuses/friends_timeline
      # @example Return the 20 most recent statuses, including retweets if they exist, posted by the authenticating user and the users they follow
      #   Twitter.friends_timeline
      def public_timeline(opts = {})
        @client.public_timeline(opts)
      end
  end

  class Base
    include TwitterLib::TimeLine

    attr_reader :client

    # expects 
    #:consumer_key, :consumer_secret, 
    #:access_key, :access_token
        
    def initialize(configuration = {})
      Twitter.configure do |config|
        config.oauth_token = configuration[:oauth_token]
        config.oauth_token_secret = configuration[:oauth_token_secret]
        config.consumer_key = configuration[:consumer_key]
        config.consumer_secret = configuration[:consumer_secret]
      end     
      
      @client = initialize_twitter_client      
    end   
    
    def self.user(screen_name = 'Super_sid')
      Twitter.user(screen_name)
    end
    
   

    private
    
    def initialize_twitter_client
      Twitter::Client.new      
    end

    end
  end

  

  user  = TwitterLib::Base.new({
    :consumer_key => "ZfUjxwKPBnOts1BXF664g",
    :consumer_secret => "U5eQDspHulRH3vBgdJY1VtyhKQcwQnEsocjVq1BFA",
    :oauth_token => "18478038-Al8rapWg1wFiDE3gIbm58NHnkiw291vX3u0fE1aBG",
    :oauth_token_secret => "ScaNHDrGIouogq4aZiDZfSuD84OXvW4hiWowhJs9h8"
    })

#tweet = user.client.home_timeline.first
#puts tweet[:user].name + "  " + tweet.text +  " " + tweet[:place].to_s





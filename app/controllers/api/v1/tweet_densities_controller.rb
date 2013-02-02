class Api::V1::TweetDensitiesController < ApplicationController
  def show
    # the key should just be the redis list to be loaded
    key = params[:id]
    number_of_tweets = (params[:number_of_tweets] || 50).to_i
    
    # used as return value, set a default density in case
    # nothing has been recorded on that hashtag or streaming
    # is down.
    # contains:
    # @density - average tweet per minute density
    @density = {the_density: 30, tag: key}
    
    # get the last 50 tweets for this 
    tweets = $redis.lrange key, (-number_of_tweets), -1

    # calculate the timespan and then tweets per minute
    # of the result set
    start_time = Time.parse(ActiveSupport::JSON.decode(tweets.first)["created_at"])
    end_time = Time.parse(ActiveSupport::JSON.decode(tweets.last)["created_at"])

    time_elapsed = end_time - start_time
    @density[:the_density] = (tweets.count / (time_elapsed/ 60)).to_i

    # if we're running out of tweets or on a slow connection then
    # call the api with quick=true, this excludes extra data like 
    # images and handles. Otherwise add extra information.
    if !params[:quick]
      #include:
      # => image(as base 64)
      # => 
      @the_tweet = ActiveSupport::JSON.decode(tweets.shuffle.first)


    end

  end
end

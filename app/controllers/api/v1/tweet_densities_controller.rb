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
    @tag = TrackedTag.find_by_term(key)
    @density[:the_density] = @tag.getDensity(number_of_tweets)

  end
end

class TrackedTag < ActiveRecord::Base
  attr_accessible :current, :term

  # return the average tweets per minute based on a sample of the 
  # last number_of_tweets tweets.
  def get_density(number_of_tweets=50)
    
    tweets = $redis.lrange self.term, (-number_of_tweets), -1
    if tweets.count > 1
    # calculate the timespan and then tweets per minute
    # of the result set
      start_time = Time.parse(ActiveSupport::JSON.decode(tweets.first)["created_at"])
      end_time = Time.parse(ActiveSupport::JSON.decode(tweets.last)["created_at"])

      time_elapsed = end_time - start_time
      if time_elapsed == 0
        time_elapsed = 1
      end
      
      return (tweets.count / (time_elapsed/ 60)).to_i
    else
      return -1
    end
  end

  # 
  def get_difficulty
  end

end

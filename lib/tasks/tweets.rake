namespace :tweets do 
  
  desc "stream tweets and dump them into REDIS"
  task :gather_live => :environment do |t|
    # Setup tweetstream with credentials
    TweetStream.configure do |config|
    config.consumer_key       = 'Fedd0Rxj5NzFG2tairVgkg'
    config.consumer_secret    = 'XWvJV662xOntliilH6Zn6OCctteJgB0KIUmDKWe6YU'
    config.oauth_token        = '21640115-Z7enSTXLKb6cxpcb5VgE8sLSDIvPPaUgZuCGsYms'
    config.oauth_token_secret = 
      'HZKwk283Gwp9KMrPWrLmLGEkxInDZqQR2KsBUZu4'
    config.auth_method        = :oauth
    end

    trending_topics = Twitter.trends
    trending_topics.each do |t|
      term = t[:name].gsub("#","")
      if TrackedTag.where(term: term).empty?
        TrackedTag.create({term: term, current:false})
      end
    end

    # pull the currently active terms/ hashtags from the db
    the_tweets = TrackedTag.where(current: true).all.collect {|c| c.term}
    the_tweets.each {|t| puts "about to start collecting for: #{t}"}

    # create a streaming client and setup some notifications if
    # we're hitting the rate limit etc
    streaming_client = TweetStream::Client.new
    streaming_client.on_limit do |skip_count|
      puts "been rate limited"
    end

    streaming_client.on_enhance_your_calm do
     puts "told to enhance calm"
    end

    # Begin streaming, pass it a block to process received tweets
    streaming_client.track(the_tweets) do |status|
      the_tweets.each do |tag|
        if status.text.include? tag
          $redis.rpush tag, status[:attrs].to_json
          puts "Adding status: #{status.text} to list: #{tag}"
        end
      end
      # command to get
      # $redis.lrange :ben_test, -10, -1
    end


  end  
end
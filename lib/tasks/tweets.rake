namespace :tweets do 
  
  desc "stream tweets and dump them into REDIS"
  task :gather_live => :environment do 
    # Setup tweetstream with credentials
    TweetStream.configure do |config|
    config.consumer_key       = 'Fedd0Rxj5NzFG2tairVgkg'
    config.consumer_secret    = 'XWvJV662xOntliilH6Zn6OCctteJgB0KIUmDKWe6YU'
    config.oauth_token        = '21640115-Z7enSTXLKb6cxpcb5VgE8sLSDIvPPaUgZuCGsYms'
    config.oauth_token_secret = 
      'HZKwk283Gwp9KMrPWrLmLGEkxInDZqQR2KsBUZu4'
    config.auth_method        = :oauth
    end

    the_tweets = ['#nowplaying']

    # Begin streaming, pass it a block to process received tweets
    TweetStream::Client.new.track(the_tweets) do |status|
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
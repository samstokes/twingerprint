require 'httparty'

class Timeline
  def initialize(username)
    @username = username
  end

  attr_reader :username

  include HTTParty
  format :json
  
  def tweets
    # TODO make this somehow async; paged_tweets is a long synchronous call
    @tweets ||= paged_tweets
  end

  def first
    tweets.last
  end

  def last
    tweets.first
  end

  def avg_tweet_frequency
    first = DateTime.parse(tweet_date(self.first))
    last = DateTime.parse(tweet_date(self.last))
    ever = last - first
    tweets.length / ever
  end

  def tweets_per_day
    grouped = tweets.group_by {|tweet| Date.parse(tweet_date(tweet)) }
    days = []
    # start a month ago, or the date of the first tweet we have,
    # whichever is more recent.
    start = [Date.today - 1.month, Date.parse(tweet_date(first))].max
    # N.B. if we choose the first tweet that probably means our data
    # is truncated, in which case we are probably also missing some
    # tweets for that first day, which will negatively bias the average.
    (start..Date.today).each do |day|
      num = grouped[day] ? grouped[day].length : 0
      days << [day, num]
    end
    days
  end

  def avg_tweets_per_day
    days = tweets_per_day
    days.map {|day, num| num }.sum / days.length
  end

  private
  def tweet_date(tweet)
    tweet["created_at"]
  end

  def paged_tweets
    paged = []
    max_id = nil
    while (page = page_of_tweets(max_id)).any?
      Rails::logger.debug("got #{page.length} tweets for user #{username}")
      paged += page
      max_id = page.last.fetch('id').to_i - 1
      raise "Unexpected 'id' in tweet: #{page.last['id']}" if max_id < 0
    end
    paged
  end

  def page_of_tweets(max_id = nil)
    params = {
      # This is tricky:
      # * Having a small value for :count means we have to make more requests
      #   to Twitter to get all a person's tweets, which uses up our API
      #   request quota quicker.
      # * Having a large value for :count seems to increase the likelihood of
      #   getting a "Fail Whale" response in the case that there actually are
      #   a lot of tweets to retrieve, thus rendering this likely to fail for
      #   people with a lot of tweets.
      #
      # Solutions:
      # * TODO fallback to only retrieving the last n tweets (where n is
      #   small enough to avoid the wrath of the Whale)
      # * TODO caching (so we don't retrieve *all* a user's tweets every time,
      #   only those we haven't seen before)
      :count => 500,
    }
    params[:max_id] = max_id if max_id

    # N.B. this doesn't do any escaping, so make sure the hash is safe
    encoded_params = params.map {|k, v| "#{k}=#{v}" }.join("&")

    url = "http://twitter.com/statuses/user_timeline/#{username}.json?#{encoded_params}"
    Rails::logger.debug("getting tweets: #{url}")
    self.class.get(url)
    # TODO check the HTTP response code
  end

end

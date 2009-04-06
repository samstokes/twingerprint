require 'httparty'

class Timeline
  def initialize(username)
    @username = username
  end

  attr_reader :username

  include HTTParty
  format :json
  
  def tweets
    @tweets ||= self.class.get("http://twitter.com/statuses/user_timeline/#{username}.json?count=200")
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

end

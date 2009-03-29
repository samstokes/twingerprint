require 'httparty'

class Timeline
  def initialize(username)
    @username = username
  end

  attr_reader :username

  include HTTParty
  format :json
  
  def tweets
    self.class.get("http://twitter.com/statuses/user_timeline/#{username}.json?count=200")
  end
end

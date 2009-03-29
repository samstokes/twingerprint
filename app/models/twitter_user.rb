require 'httparty'

class TwitterUser
  def initialize(username)
    @username = username
  end

  attr_reader :username

  include HTTParty
  format :json

  def name
    data["name"]
  end

  def screen_name
    data["screen_name"]
  end

  private
  def data
    @data ||= self.class.get("http://twitter.com/users/show/#{username}.json")
  end
end

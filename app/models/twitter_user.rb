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

  def profile_image_url
    data["profile_image_url"]
  end

  private
  def data
    @data ||= self.class.get("http://twitter.com/users/show/#{username}.json")
    # TODO check the HTTP response code
  end
end

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
    @data ||= get_user_data
  end

  def get_user_data
    url = "http://twitter.com/users/show/#{username}.json"
    returning self.class.get(url) do |response|
      unless response.code.to_s =~ /^2/
        raise "Error getting user data: " +
            "HTTP #{response.code} #{response.message}\n#{response.body}"
      end
    end
  end
end

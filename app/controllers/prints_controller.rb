class PrintsController < ApplicationController

  def show
    @print = Print.new(params.fetch(:username)); return
    username = params.fetch(:username)

    Net::HTTP.start("twitter.com") do |http|
      resp = http.get("/users/show/#{username}.xml")
      raise "#{resp.code} #{resp.message}" unless Net::HTTPSuccess === resp
      xml = REXML::Document.new(resp.body)
      names = xml.elements.collect("/user/name", &:text)
      display_name = names.join(", ") # there's only one anyway

      resp = http.get("/statuses/user_timeline/#{username}.xml?count=200")
      raise "#{resp.code} #{resp.message}" unless Net::HTTPSuccess === resp
      xml = REXML::Document.new(resp.body)
      tweets = xml.elements.collect("/statuses/status/text", &:text)

      words = Hash.new(0)
      tweets.each do |tweet|
        tweet.split(/[-\s]/).each do |word|
          words[word] += 1 unless word.empty? || common_words.include?(word.downcase)
        end
      end

      # render :text => words.
      #   sort {|w, x| x[1] <=> w[1] }.
      #   map {|word, freq| word + " (#{freq})" }.
      #   join("<br>")
      render :text => "<h1>#{display_name}</h1>" + word_cloud(words)
    end
  end

  private
  def common_words
    Set.new(%w(
      the to is a i in for and of on but that can with you at was not as have
      it your be my this by get i'm will or so if are we has
    ))
  end

end

class PrintsController < ApplicationController

  def show
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
          words[word] += 1 unless word.empty? || common_words.include?(word)
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
    %w(the to is a I in for and of on but that can with you at was not as have
       it)
  end

  def word_cloud(words_freqs)
    words_freqs = words_freqs.sort {|x, y| y[1] <=> x[1] }[0,50]
    # now words_freqs.first[0] is the most frequent word
    max_freq, min_freq = words_freqs.first[1], words_freqs.last[1]
    min_log_freq = Math.log(min_freq)
    max_log_spread = Math.log(max_freq) - min_log_freq
    max, min = 200.0, 50.0
    scale = max - min

    words = []
    words_freqs.each do |word, freq|
      log_spread = Math.log(freq) - min_log_freq
      offset = log_spread / max_log_spread
      size = min + scale * offset
      words << "<span style='font-size: #{size.to_i}%'>#{word}</span>"
    end

    "<div style='width: 25em'>" + words.join("\n") + "</div>"
  end

end

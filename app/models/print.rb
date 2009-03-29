class Print
  def initialize(username)
    @user = TwitterUser.new(username)
    @timeline = Timeline.new(username)
  end

  attr_reader :user, :timeline

  def title
    "#{user.name} (#{user.screen_name})"
  end

  def word_frequencies
    @timeline.tweets.inject(Hash.new(0)) do |word_freqs, tweet|
      tweet["text"].split(/[-\s]/).each do |word|
        word_freqs[word] += 1 unless ignore?(word)
      end
      word_freqs
    end
  end

  private
  def ignore?(word)
    word.empty? || common_words.include?(word.downcase)
  end

  def common_words
    Set.new(%w(
      the to is a an i in for and of on but that can with you at was not as have
      it your be my this by get i'm will or so if are we has rt
    ))
  end

end

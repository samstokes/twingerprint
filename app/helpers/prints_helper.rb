module PrintsHelper

  def cloud(words_freqs, min_percent = 50.0, max_percent = 200.0)
    words_freqs = words_freqs.sort {|x, y| y[1] <=> x[1] }[0,50]
    # now words_freqs.first[0] is the most frequent word
    max_freq, min_freq = words_freqs.first[1], words_freqs.last[1]
    min_log_freq = Math.log(min_freq)
    max_log_spread = Math.log(max_freq) - min_log_freq
    scale = max_percent - min_percent

    words = []
    words_freqs.each do |word, freq|
      log_spread = Math.log(freq) - min_log_freq
      offset = log_spread / max_log_spread
      size = min_percent + scale * offset
      words << "<span style='font-size: #{size.to_i}%'>#{word}</span>"
    end

    "<div class='cloud'>" + words.join("\n") + "</div>"
  end

end

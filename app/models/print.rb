class Print
  def initialize(username)
    @username = username
  end

  attr_reader :username

  def title
    username
  end

  def word_data
    # TODO
    [["foo", 10], ["bar", 5]]
  end
end

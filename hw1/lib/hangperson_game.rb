class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses
  def initialize(word)
  	@word = word.downcase
  	@guesses = ""
  	@wrong_guesses = ""
    @word_with_guesses = ""
    @word.length.times do
      @word_with_guesses += "-"
    end
    @counter = 0
  end

  def guess(letter)
    if !checkValidLetter(letter)
      raise ArgumentError
    end

    letter = letter.downcase
    if @word.include? letter
      if !@guesses.include? letter
        @guesses += letter  
      else
        return false
      end
      (0...@word.length).each do |i|
        if letter == @word[i]
          @word_with_guesses[i] = letter
        end
      end
    else
      if !@wrong_guesses.include? letter
        @wrong_guesses += letter
        @counter += 1
      else
        return false
      end
    end
    return true
  end

  def check_win_or_lose
    if @word_with_guesses.include? "-"
      if @counter < 7
        return :play
      else
        return :lose
      end
    else
      return :win
    end
  end

  def checkValidLetter(letter)
    letter =~ /[A-Za-z]/
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

end

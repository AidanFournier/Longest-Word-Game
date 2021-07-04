require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @letters
  end

  def score
    @word = params[:word].upcase
    real_word = check_dictionary(@word)
    is_in_grid = check_if_in_original_letters_grid(@word, params[:letters])
    # start_time = params[:start_time].to_i
    # end_time = params[:end_time].to_i
    # @play_time = start_time - end_time
    @score = @word.length
    @final_message = calibrate_message(@word, is_in_grid, real_word)
  end

  def calculate_score(word, time, is_in_grid, real_word)
    if is_in_grid && real_word
      word.length / time
    else
      0
    end
  end

  def calibrate_message(word, is_in_grid, real_word)
    if is_in_grid && real_word
      "Congratulations, #{word} is a valid English word!"
    elsif is_in_grid && !real_word
      "This is not an English word. You lose."
    else
      "Not in the grid."
    end
  end

  private

  def check_if_in_original_letters_grid(word, grid)
    word.chars.all? do |letter|
      word.count(letter) <= grid.count(letter)
    end
  end

  def check_dictionary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_hash = JSON.parse(URI.open(url).read)
    word_hash["found"]
  end
end

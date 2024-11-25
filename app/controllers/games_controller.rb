require 'open-uri'

class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:score]

  def new
    alphabet = ("A".."Z").to_a
    grid_size = 10

    @letters = Array.new(grid_size) { alphabet.sample }
  end

  def score
    user_word = params[:word].upcase
    grid = params[:grid].split(',')

    is_valid_word = valid_word?(user_word)
    is_in_grid = in_grid?(user_word, grid)

    if is_valid_word && is_in_grid
      score = calculate_score(user_word)
      @message = "Congratulations! #{user_word} is a valid English word."
    elsif !is_in_grid
      score = 0
      @message = "Sorry but #{user_word} can't be built..."
    else
      score = 0
      @message = "Sorry but #{user_word} does not seem to be a valid English word..."
    end

    @score = score
    @user_word = user_word
    @message = @message
  end

  def valid_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    result = JSON.parse(response)
    result['found']
  end

  def in_grid?(word, grid)
    word.chars.all? do |char|
      grid.include?(char) && grid.count(char) >= word.count(char)
    end
  end

  def calculate_score(word)
    word.length
  end

end

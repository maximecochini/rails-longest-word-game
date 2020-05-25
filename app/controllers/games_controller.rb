require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].split(" ")
    @attempt = params[:word]
    if params[:word].size == 0
      @result = { score: 0,
                  resolve: -1,
                  attempt: @attempt,
                  letters: @letters }
    elsif match?(@attempt, @letters) == false
      @result = { score: 0,
                  resolve: 0,
                  attempt: @attempt,
                  letters: @letters }
    elsif correct?(@attempt)["found"] == false
      @result = { score: 0,
                  resolve: 1,
                  attempt: @attempt,
                  letters: @letters }
    else
      @result = { score: 100,
                  resolve: 2,
                  attempt: @attempt,
                  letters: @letters }
    end
  end

  private

  def match?(attempt, grid)
    lettersattempt = attempt.upcase.split("").sort
    letterscount = {}
    ('A'..'Z').each { |letter| letterscount[letter] = 0 + grid.count(letter) - lettersattempt.count(letter) }
    return letterscount.values.min.negative? ? false : true
  end

  def correct?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionary = open(url).read
    return JSON.parse(dictionary)
  end
end

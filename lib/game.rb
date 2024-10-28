# frozen_string_literal: true

# Tracks and controls game state
class Game
  attr_reader :secret_word, :wrong_guess_limit, :letters_solved, :guess

  def initialize(wrong_guess_limit = 7)
    @dictionary = create_dictionary('google-10000-english-no-swears.txt')
    @secret_word = select_secret_word.split('')
    @wrong_guesses = 0
    @wrong_guess_limit = wrong_guess_limit
    @not_in_sw = []
    @letters_solved = Array.new(secret_word.length, '_')
    @guess = false
  end

  def create_dictionary(file)
    File.readlines(file, chomp: true).each_with_object([]) do |word, dictionary|
      dictionary << word if word.length > 5 && word.length <= 12
    end
  end

  def select_secret_word
    @secret_word = @dictionary.sample
  end

  def get_guess
    puts 'What letter would you like to guess?'
    @guess = gets.chomp[0]
  end
end

game = Game.new
p game.secret_word
p game.wrong_guess_limit
p game.letters_solved

game.get_guess

p game.guess

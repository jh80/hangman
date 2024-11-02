# frozen_string_literal: true

require '~/repos/hangman/lib/printable'
require 'yaml'

# Tracks and controls game state
class Game
  include Printable

  attr_accessor :secret_word, :not_in_sw, :letters_solved
  attr_reader :wrong_guess_limit, :guess

  def initialize(wrong_guess_limit = 7)
    @dictionary = create_dictionary('google-10000-english-no-swears.txt')
    @secret_word = select_secret_word.split('')
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
    loop do
      puts 'What letter would you like to guess?'
      @guess = gets.chomp[0].downcase
      break unless already_guessed?
    end
  end

  def already_guessed?
    return unless @not_in_sw.include?(@guess) || @letters_solved.include?(@guess)

    puts 'You already guessed that, best not to guess it again :)'
    true
  end

  def allocate_guess
    if @secret_word.include?(@guess)
      add_solved_letter
    else
      @not_in_sw << @guess
    end
  end

  def add_solved_letter
    @secret_word.each_with_index do |secret_letter, i|
      @letters_solved[i] = @guess if secret_letter == @guess
    end
  end

  def display_round_results
    puts @letters_solved.join(' ')
    # print_box(@not_in_sw)
    puts "Incorrect guesses: #{@not_in_sw.join(', ')}"
    puts "You have #{wrong_guesses_left} incorrect guesses left"
  end

  def wrong_guesses_left
    @wrong_guess_limit - @not_in_sw.length
  end

  def play_round
    get_guess
    allocate_guess
    display_round_results
  end

  def play
    display_round_results
    loop do
      if @secret_word == @letters_solved
        puts "You did it! the word was #{@secret_word.join}! You solved it with #{wrong_guesses_left} incorrect guesses to spare"
        break
      elsif wrong_guesses_left.zero?
        puts "Dang! You ran out of guesses. The word was #{@secret_word.join}"
        break
      end
      play_round
      if save?
        save_game
        break
      end
    end
  end

  def save?
    loop do
      puts 'Would you like to save your game? Y or N'
      answer = gets.chomp
      return true if answer[0].downcase == 'y'
      return false if answer[0].downcase == 'n'
    end
  end

  def save_game
    puts 'What would you like to name the game?'
    file_name = gets.chomp
    make_game_file(file_name)
  end

  # def to_yaml
  #   YAML.dump(self)
  # end

  def to_yaml_hash
    YAML.dump({
                secret_word: @secret_word,
                wrong_guess_limit: @wrong_guess_limit,
                not_in_sw: @not_in_sw,
                letters_solved: @letters_solved
              })
  end

  def self.from_yaml_hash(string)
    data = YAML.load string
    load_data(data[:secret_word], data[:wrong_guess_limit], data[:not_in_sw], data[:letters_solved])
  end

  def self.load_data(secret_word, wrong_guess_limit, not_in_sw, letters_solved)
    game = new(wrong_guess_limit)
    game.secret_word = secret_word
    game.not_in_sw = not_in_sw
    game.letters_solved = letters_solved
    game
  end

  def make_game_file(file_name)
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')

    filename = "saved_games/#{file_name}.yaml"

    File.open(filename, 'w') do |file|
      file.puts to_yaml_hash
    end
  end
end

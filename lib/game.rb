# frozen_string_literal: true

# Tracks and controls game state
class Game
  attr_reader :secret_word, :wrong_guess_limit, :letters_solved, :guess, :not_in_sw

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
      @guess = gets.chomp[0]
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
    puts @letters_solved.join(' ')
    loop do
      if @secret_word == @letters_solved
        puts "You did it! the word was #{@secret_word.join}! You solved it with #{wrong_guesses_left} incorrect guesses to spare"
        break
      elsif wrong_guesses_left.zero?
        puts "Dang! You ran out of guesses. The word was #{@secret_word.join}"
        break
      end
      play_round
    end
  end
end

game = Game.new
game.play

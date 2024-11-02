require '~/repos/hangman/lib/game'

def y_or_n?(question)
  loop do
    puts question
    answer = gets.chomp.downcase
    return true if answer[0].downcase == 'y'
    return false if answer[0].downcase == 'n'
  end
end

def get_file_to_play
  puts 'Enter the saved game you would like to play from the options below?'
  file_names = Dir.children('/Users/jenniferhonka/repos/hangman/saved_games')
  puts file_names
  get_valid_file_name(file_names)
end

def get_valid_file_name(valid_files_list)
  loop do
    file_to_play = gets.chomp
    return file_to_play if valid_files_list.include?(file_to_play)

    puts 'Make sure you have spelled the file correctly and that it is in the above list.'
  end
end

play_save = y_or_n?('Would you like to play a saved game?')
if play_save
  file_name = get_file_to_play
  saved_game = "saved_games/#{file_name}"
  contents = File.read(saved_game)
  game = Game.from_yaml_hash(contents)
else
  game = Game.new
end
game.play

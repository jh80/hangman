require game.rb

def create_dictionary(file)
  File.readlines(file).each_with_object([]) do |word, dictionary|
    dictionary << word if word.length > 5 && word.length <= 12
  end
end

dictionary = create_dictionary('google-10000-english-no-swears.txt')

secret_word = dictionary.sample

puts secret_word

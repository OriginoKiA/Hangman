@num_of_guesses = 8
@hints_left = 4
@complete = false


def start
  random_word = get_random_word
  puts %{Type SAVE to save the game\n
Type LOAD to load a saved game\n
Type HINT to get a hint\n
Type EXIT to exit game\n}
  display(random_word)
end

def get_random_word() #get a random word from 5desk.txt with a random wordlength
    dict = File.readlines "5desk.txt"
    word_length = rand (5..12)
    word = ""
    while true
        break if word.length == word_length
        word = dict[rand(61406)]
    end
    return word
end

def display (word)
    new_word = Array.new(word.length-1,"_")
    play(new_word,word)
end

def play(new_word,word)
  while @num_of_guesses != 0 && @complete == false
    print "YOU WIN!" if @complete
    print new_word.join(" ")
    guess = get_guess
    new_word = get_hint(new_word,word) if guess == "HINT"
    save(new_word,word) if guess == "SAVE"
    break if guess == "EXIT"
    load_save if guess == "LOAD"
    new_word = replace_new_word(guess,new_word,word) if in_word(guess,word)
  end
  puts
  puts "The word was #{word}"
  puts "END OF GAME"
end

def get_guess
  puts
  print "Enter guess: "
  guess = gets.chomp
  return guess
end

def in_word (guess,word)
  i = 0
  while i < word.length
    return true if word[i] == guess
    return true if guess == "SAVE"
    return true if guess == "LOAD"
    return true if guess == "EXIT"
    i += 1
  end
  count_guesses
end

def replace_new_word (guess,new_word,word)
  i = 0
  while i < word.length
    new_word[i] = guess if word[i] == guess && new_word[i] == "_"
    i += 1
  end
  return new_word
end

def count_guesses
  @num_of_guesses -= 1
  puts "GUESSES LEFT: #{@num_of_guesses}"
  return false
end

def get_hint (new_word,word)
  return nil if @hints_left <= 0
  @hints_left -= 1
  puts "HINTS LEFT: #{@hints_left}"
  replace_new_word(word[rand(word.length)],new_word,word)
end

def determine_save_number
  number = 0
  while File.exists?("saves/save#{number}.txt")
    number += 1
  end
  save_number = "#{number}"
  return save_number
end

def save (new_word,word)
  puts "Saving game"
  Dir.mkdir("saves") unless Dir.exists?("saves")
  save_number = determine_save_number
  filename = "saves/save#{save_number}.txt"
  File.open(filename,"w") do |file|
    file.puts "#{@num_of_guesses}"
    file.puts "#{@hints_left}"
    file.puts "#{new_word}"
    file.puts "#{word}"
  end
  puts "Game saved"
end

def load_save
  puts "Type in file to load: "
  to_load = gets.chomp
  loaded = File.readlines "saves/" + to_load
  new_word = loaded[2]
  word = loaded[3]
  @num_of_guesses = loaded[0]
  @hints_left = loaded[1]
  play(new_word,word)
end

start

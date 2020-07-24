def new_game
    secret_words = File.readlines "5desk.txt"
    $secret_word = secret_words[rand(secret_words.length)].downcase.chop
    $shown_word=[]
    $wrong_guesses=[]
    $used_guesses=[]
    $secret_word.length.times do |i|
        $shown_word[i]="_"
    end
    $wrong_guesses_counter=0
    print_results
end
def save_game
    puts "game has been saved"
    array = [$shown_word, $wrong_guesses, $used_guesses, $secret_word, $wrong_guesses_counter]
    Dir.mkdir("saved_games") unless Dir.exist? ("saved_games")
    saved_game = File.open("saved_games/saved_game.txt", "w")
    array.each do |element|
        saved_game.puts "#{element}"
    end
    saved_game.close
end
def load_game
    if File.exist? "saved_games/saved_game.txt"
        saved_game = File.readlines("saved_games/saved_game.txt")
        row_index=0
        saved_game.map do |line|
            row_index+=1
            $shown_word = (((line.delete "\"").delete "]").delete"[").chop.split(", ") if row_index==1
            $wrong_guesses = (((line.delete "\"").delete "]").delete"[").chop.split(", ") if row_index==2
            $used_guesses = (((line.delete "\"").delete "]").delete"[").chop.split(", ") if row_index==3
            $secret_word = line.chop if row_index==4
            $wrong_guesses_counter = line.chop.to_i if row_index==5
        end
        print_results
    else
        puts "No game is saved"
        start_game
    end
end
def play_turn
    puts " enter your next guess or \"save\" to save the game and exit"
    $guess= gets.chop.downcase
    if $guess == "save"
        save_game
        $game_ended = "true"
    else
        check_guess
    end
end
def check_guess
    if $guess.length == 1
        if $used_guesses.include? $guess
            puts "you guessed that already"
            play_turn
        elsif $secret_word.include? $guess
            puts "Your guess is right"
            x=$secret_word.split("")
            x.each_with_index do |element, index|
                if element==$guess
                    $shown_word[index]=$guess
                end
            end
            $used_guesses.push($guess)
        elsif $wrong_guesses.include? $guess
                puts " You know it's wrong -,-"
                play_turn
        else
            puts "Oops! wrong guess"
            $wrong_guesses.push($guess)
            $wrong_guesses_counter+=1
        end
    else
        puts "You can guess 1 letter at a time"
    end
    print_results
end
def check_game
    if $wrong_guesses_counter==8
        puts "You lost! the secert word is \"#{$secret_word}\""
    elsif $shown_word.join==$secret_word
        puts "Well done!, you won"
        $game_ended ="true"
    end
end
def print_results
    puts "Secert word: #{$shown_word}"
    puts "Wrong letters: #{$wrong_guesses},    Wrong guesses: \(#{$wrong_guesses_counter}\)"
end
def start_game
    $game_ended = "false"
    puts "for a new game enter \"new\", to load a saved game enter \"load\""
    game_mode = gets.chop.downcase
    if game_mode == "new" || game_mode == "load"
        if game_mode == "new"
            new_game
        elsif game_mode == "load"
            load_game
        end
        while $wrong_guesses_counter!=8 && $game_ended == "false"
            play_turn
            check_game
        end
    else
        puts "Wrong option"
        start_game
    end
end
start_game
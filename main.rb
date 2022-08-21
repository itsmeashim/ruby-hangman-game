require 'uri'
require 'net/http'
require 'json'

def getword()
    uri = URI('https://random-word-api.herokuapp.com/word')
    res = Net::HTTP.get_response(uri)
    JSON(res.body)[0] if res.is_a?(Net::HTTPSuccess)
end

def getmeaning(gword) 
    url = 'https://api.dictionaryapi.dev/api/v2/entries/en/' + gword.to_s
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    JSON(res.body)[0]['meanings'][0]['definitions'][0]['definition'] if res.is_a?(Net::HTTPSuccess)
end

def maintemplate()
    puts "======================== Welcome to Hangman ========================"
end

def printpics(error)
    pics = ["  +---+\n  |   |\n      |\n      |\n      |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n      |\n      |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n  |   |\n      |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n /|   |\n      |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n /|\\  |\n      |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n /|\\  |\n /    |\n      |\n=========",
    "  +---+\n  |   |\n  O   |\n /|\\  |\n / \\  |\n      |\n========="]

    puts `clear`
    maintemplate
    puts pics[error - 1] if error != 0
    puts "You have " + String(7 - (error)) + " attempts left."
end

def show(gword, guessed_word, show_array,wlength,error)       
    printpics(error)
    puts
    puts "Word Meaning: "
    puts getmeaning(gword)
    puts
    blank = "_"
    puts "The word: "
    for i in 0..wlength-1
        if gword[i] == guessed_word
            show_array[i] = guessed_word
        end

        if show_array[i] == nil
            print(blank)
        else
            print(show_array[i])
        end
    end
    puts
end

def game()
    maintemplate
    puts "You have 7 attempts to complete it."
    error = 0
    gword = getword
    
    wlength = gword.to_s.length
    show_array = Array.new(wlength)
    guessed_word = ''

    while true
        show(gword, guessed_word, show_array, wlength,error)
        if !show_array.any?{ |e| e.nil? }
            puts "Congratulations! You won!!"
            return
        end
        
        puts "==============================================================="
        print "Enter your guess letter: "
        guessed_word = gets.chomp
        if !(guessed_word.length == 1 && guessed_word.to_i == 0 && guessed_word != nil)
            puts
            puts "Alert!!"
            puts "Only one letter at a time and only strings."
            sleep 1
            next
        end


        if gword.index(guessed_word) == nil
            error = error + 1
            printpics(error)
        end

        if error == 7
            puts
            puts "Game Over!"
            puts "You lost!!"
            puts "The word was: " + gword
            return
        end
        
    end

end

game()

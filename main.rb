require 'io/console'
module Mastermind

  class Setup
  
    def self.master_selection
      puts "H if you want a human master | A if you want an automated master"
      choice = user_input
      if choice == "H"
         Master.new(Colors.new, Clues.new)
      elsif choice == "A"
        AutomatedMaster.new(AutomatedMasterColors.new, AutomatedClues.new) 
      else
        puts "Wrong input, try again"
        master_selection
      end
    end

    def self.hacker_selection
      puts "H if you want a human hacker | A if you want an automated hacker"
      self.choice_flow(user_input, Hacker.new(Colors.new), AutomatedHacker.new(AutomatedHackerColors.new))
    end
    
    def self.choice_flow(choice,human, automated)
      if choice == "H"
        human
      elsif choice == 'A'
        automated
      else
        puts "wrong input, try again"
        hacker_selection
      end
    end

    def self. user_input
      gets.chomp
    end
  
  end
  class Game
    def initialize(master, hacker)
      @master = master
      @hacker = hacker
    end

    def play
      @master.create_secret_code
      hacking_attemps
      master_won
    end

    def hacking_attemps
      12.times do
        round
      end
    end
    
    def round
      @hacker.crack_attempt
      hacker_won?
      master_turn
      display_results
    end

    def master_turn
      compare_combinations
      @master.give_clues
    end

    def compare_combinations
     @master.comparing(@hacker.combination)
    end

    def display_results
      @hacker.history.each_with_index do |comb, i|
        puts "turn #{i + 1} combination: #{comb}        clues: #{@master.history[i]}"
        puts '---------------------------------------------------------------------'
      end
    end

    def hacker_won?
     if @hacker.combination ==  @master.secret
       puts "Hacker has guessed the combination, hacker wins!!"
       exit 
     end
    end

    def master_won
      puts "Master won as his code was never discovered! #{@master.secret}"
    end
  end 

  class Master
    def initialize(colors, clues)
      @colors = colors
      @clues = clues
    end

    def create_secret_code
      puts "Master turn to choose colors"
      @colors.choice_loop
    end

    def secret
      @colors.combination
    end

    def give_clues
      @clues.clear
      @clues.choice_loop
      @clues.add_record
    end

    def comparing(hacker_combination)
           puts "Hacker don't cheat and look away
           secret: #{secret}
           hack: #{hacker_combination}
      "
    end

    def history
      @clues.history
    end
  end
  class Colors
    def initialize
      @colors = ['red', 'blue', 'orange', 'yellow', 'green', 'purple']
      @combination = Array.new
      @history = Array.new
    end

    attr_reader :combination, :history
    
    def prompt
      puts "choose 4 colors from 1-6, input one number at a time and then click enter #{@colors}"
    end

    def choose!
      color_index = STDIN.noecho(&:gets)
      @combination.push(@colors[color_index.to_i - 1]) if right_input?(color_index.to_i - 1)
    end

    def right_input?(index)
      if index < 0 || index > 5 || index.class != Integer
        puts 'wrong input!'
        choose!
        false
      else
        true
      end
    end

    def choice_loop
      prompt
      4.times do 
        choose!
      end
    end
    
    def clear
      @combination = []
    end
        

    def add_record
      @history.push(@combination)
    end
  end
  class Clues
    def initialize
      @combination = Array.new
      @history = Array.new
    end
    attr_reader :combination, :history

    def choose!
      input = gets.chomp
      @combination.push(input) if right_input?(input)
    end

    def choice_loop
      prompt      
      4.times do
        choose!
      end
    end

    def right_input?(clue)
      return true if clue.match?(/[WwBb ]/)
      puts "wrong input"
      choose!
    end

    def prompt
      puts 'W if it is in index and color, B if its only the color, empty space if its none'
    end

    def clear
      @combination = Array.new
    end

    def add_record
      @history.push(@combination)
    end
  end

  class AutomatedMaster < Master
    def initialize(colors, clues)
      super(colors, clues)
    end

    def create_secret_code
      @colors.choice_loop
      puts "Code is ready, try to hack it!"
    end

    def comparing(hacker_combination)
      @clues.clear
      @clues.choice_loop(hacker_combination,secret)
    end

    def give_clues
      @clues.shuffle
      @clues.add_record
    end

  end
  class AutomatedMasterColors < Colors
    def choose!
      color_index = rand(0..5)
      @combination.push(@colors[color_index]) if right_input?(@colors[color_index])
    end

    def right_input?(color)
      if @combination.include?(color)
        choose!
        false
      else
        true
      end
    end

    def prompt 
      puts "Master is creating the secret code..."
    end
  end
  class AutomatedClues < Clues

    def choice_loop(hacker_combination, secret)
      hacker_combination.each_with_index do |c, i|
           choose!(c, i, secret)
        end
    end

    def shuffle
      @combination = @combination.shuffle
    end
    
    def choose!(c, i, secret)
      if secret.find_index(c) == i
        @combination.push('B') 
      elsif secret.include?(c)
        @combination.push('W')
      else 
        @combination.push(' ') 
      end
    end
  end

  class Hacker
    def initialize(colors)
      @colors = colors
    end

    def crack_attempt
      puts "Hacker turn"
      @colors.clear
      @colors.choice_loop
      @colors.add_record
    end

    def history
      @colors.history
    end

    def combination
      @colors.combination
    end
  end
  class AutomatedHacker < Hacker
    def initialize(colors)
      super(colors)
    end
  end
  class AutomatedHackerColors < AutomatedMasterColors
    def prompt
      puts "trying to crack the code..."
    end
  end
end


include Mastermind


game = Game.new(Setup.master_selection, Setup.hacker_selection)
game.play

require 'io/console'
module Mastermind
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
      puts "Hacker don't cheat and look away
           secret: #{@master.secret}
           hack: #{@hacker.combination}
      "
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
  class Colors
    def initialize
      @colors = ['red', 'blue', 'orange', 'yellow', 'green', 'purple']
      @combination = Array.new
    end

    attr_reader :combination
    
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
      end
      true
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
  end

  class HackerColors < Colors
    def initialize
      super
      @history = Array.new
    end

    attr_reader :history

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

  class AutomatedClues
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

    def history
      @clues.history
    end
  end

  class AutomatedMaster < Master
    def initialize(colors)
      super(colors)
    end
  
    def automated_clues(hacker_combination)
      clues_array = clues_loop([],hacker_combination)
      @clues.push(clues_array)
    end

    def clues_loop(array, hacker_combination)
      hacker_combination.each_with_index do |c, i|
           clues_conditionals(c, i, array)
        end
        
      array.shuffle
    end

    
    def clues_conditionals(c, i, array)
      if self.combination.find_index(c) == i
        array.push('B') 
      elsif self.combination.include?(c)
        array.push('W')
      else 
        array.push(' ') 
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

end

include Mastermind

master_colors = Colors.new
hacker_colors = HackerColors.new
human_clues = Clues.new
master = Master.new(master_colors, human_clues)
hacker = Hacker.new(hacker_colors)
game = Game.new(master, hacker)
game.play
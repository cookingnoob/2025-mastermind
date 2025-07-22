require 'io/console'
module Mastermind
  class Game
    def initialize(master, hacker)
      @master = master
      @hacker = hacker
    end

    def play
      @master.create_secret_code
      attemps
    end

    def attemps
      12.times do
        round
      end
    end

    def round
      @hacker.hack_attempt  #Hacker
      winner? #Game
      #@master.clues(@hacker.chosen_colors) # Clues
      #display_results #Game
    end

    def display_results
      @hacker.history.each_with_index do |comb, i|
        puts "turn #{i + 1} combination: #{comb}        clues: #{@master.clues[i]}"
        puts '---------------------------------------------------------------------'
      end
    end

    def winner?
     if @hacker.combination ==  @master.combination
       puts "Hacker has guessed the combination, hacker wins!!"
       exit 
     end
    end
  end
  class Colors
    def initialize
      @colors = ['red', 'blue', 'orange', 'yellow', 'green', 'purple']
      @combination = Array.new
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
  
  class Master
    attr_reader :clues, :history
    def initialize(colors)
      @colors = colors
      @clues = Array.new
      @history = Array.new
    end

    def create_secret_code
      puts "Master turn to choose colors"
      @colors.choice_loop
      p "combination: ", combination      
    end

    def combination
      @colors.combination
    end

    def clues
      clues_prompt      
      4.times do
        @clues.push(gets.chomp)
      end
    end

    def clues_prompt
      puts 'W if it is in index and color, B if its only the color, empty space if its none'
    end

    def clean
      @clues = Array.new
    end

    def add_record
      @history.push(@clues)
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
      p "combination: ", combination
      p "history: ", history
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
master = Master.new(master_colors)
hacker = Hacker.new(hacker_colors)
game = Game.new(master, hacker)
game.play
require 'io/console'
module Mastermind
  class Game
    attr_reader :colors

    def initialize
      @master = Master.new
      @hacker = Hacker.new
    end

    def play
 #     choose_rol
      @master.turn
      @hacker.turn
    end

    # def choose_rol
    #   puts 'choose if you want to be master or hacker? m/h'
    #   gets.chomp
    #   @master = true  if rol == 'h'
    #   @hacker = true if rol == 'm'
    # end

    def computer_master_human_hacker
      puts 'missing logic for computer choice'
      turn_loop
      puts "Master won as the combination was not discovered! #{@master.combination}"
    end
    
    def human_master_computer_hacker
      @master.turn
      puts 'missing logic for simulating hacker'
    end

    def turn_loop
      12.times do
        turn_flow
      end
    end

    def turn_flow
      @hacker.turn
      winner?
      #@master.automated_clues(@hacker.chosen_colors)
      @hacker.clear_selection
      display_results
    end

    def display_results
      @hacker.combination.each_with_index do |comb, i|
        puts "turn #{i + 1} combination: #{comb}        clues: #{@master.clues[i]}"
        puts '---------------------------------------------------------------------'
      end
    end

    def winner?
     if @hacker.chosen_colors ==  @master.combination
       puts "Hacker has guessed the combination, hacker wins!!"
       exit 
     end
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

    def add_record
      @history.push(@combination)
    end

  end

  class Clues
    def initialize
      @current = Array.new
      @history = Array.new
    end
  end
  class Master
    attr_reader :clues
    def initialize
      @colors = Colors.new
      @bot = false
      @clues = Array.new
    end

    def turn
      puts "Master turn to choose colors"
      @colors.choice_loop
      p "combination: ", combination      
    end

    def combination
      @colors.combination
    end

    def automated_clues(hacker_combination)
      clues_array = clues_loop([],hacker_combination)
      @clues.push(clues_array)
    end
    # controller for redirecting actions if master is a bot
    # same for hacker

    def clues
      puts 'W if it is in index and color, B if its only the color, empty space if its none'
      clues = []
      4.times do
        clues.push(gets.chomp)
      end
      @clues.push(clues)
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
    def initialize
      @colors = Colors.new
    end

    def turn
      puts "Hacker turn"
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

end

include Mastermind

game = Game.new
game.play
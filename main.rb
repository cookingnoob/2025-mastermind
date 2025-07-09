require 'io/console'
module Mastermind
  class Game
    attr_reader :colors

    def initialize
      @colors = ['red', 'blue', 'orange', 'yellow', 'green', 'purple']
      @master = Master.new(self)
      @hacker = Hacker.new(self)
    end

    def play
      rol = choose_rol
      computer_master_human_hacker 
      human_master_computer_hacker if rol == 'm'
    end

    def choose_rol
      puts 'choose if you want to be master or hacker? m/h'
      gets.chomp
      @master = true  if rol == 'h'
      @hacker = true if rol == 'm'
    end

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
      @master.automated_clues(@hacker.chosen_colors)
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

  class Player
    def initialize(game)
      @game = game
      @chosen_colors = Array.new
      @combination = Array.new
    end
    attr_reader :chosen_colors, :combination

    def color_to_choose
      puts "choose 4 colors from 1-6, input one number at a time and then click enter #{@game.colors}"
    end


    def choose_colors!
      color_index = STDIN.noecho(&:gets)
      @chosen_colors.push(@game.colors[color_index.to_i - 1]) if right_input?(color_index.to_i - 1)
    end

    def right_input?(index)
      if index < 0 || index > 5 || index.class != Integer
        puts 'wrong input!'
        choose_colors!
      end
      true
    end

    def colors_loop
      color_to_choose
      4.times do 
        choose_colors!
      end
    end
    
    def clear_selection
      @chosen_colors = []
    end

  end

  class Master < Player
    attr_reader :clues
    def initialize(game)
      super(game)
      @bot = false
      @clues = Array.new
    end

    def turn
      puts "Master turn to choose colors"
      self.colors_loop
      @combination = @chosen_colors      
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

  class Hacker < Player
    def initialize
      @bot = false  
    end

    def turn
      puts "Hacker turn"
      self.colors_loop
      @combination.push(@chosen_colors)
    end
  end

end

include Mastermind

game = Game.new
game.play
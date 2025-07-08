require 'io/console'

module Mastermind
  class Game
    attr_reader :hidden_combination, :colors

    def initialize
      @master_combination = Array.new
      @hacker_combinations = Array.new
      @colors = ['red', 'blue', 'orange', 'yellow', 'green', 'purple']
      @master = Master.new(self)
      @hacker = Hacker.new(self)
    end

    def add_master_color!(color)
      @master_combination.push(color)
    end

    def play
      master_turn
      puts "Guess the colors and their order!"
    end

    def master_turn
      puts "Master turn to choose colors"
      @master.colors_loop
      @master_combination = @master.chosen_colors      
    end

  end

  class Player
    def initialize(game)
      @game = game
      @chosen_colors = []
    end
    attr_reader :chosen_colors

    def color_to_choose
      puts 'choose 4 colors from 1-6, input one number at a time and then click enter', @game.colors
    end


    def choose_colors!
      color_index = STDIN.noecho(&:gets)
      @chosen_colors.push(@game.colors[color_index.to_i]) if right_input?(color_index.to_i)
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
    
  end

  class Master < Player
  end

  class Hacker < Player
  end

end

include Mastermind

game = Game.new
game.play
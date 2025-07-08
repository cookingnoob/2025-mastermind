require 'io/console'

module Mastermind
  class Game
    attr_reader :hidden_combination, :colors

    def initialize
      # @master_combination = Array.new
      @master_combination = ['blue', 'red', 'yellow', 'green']
      @hacker_combinations = Array.new
      @hacker_clues = Array.new
      @colors = ['red', 'blue', 'orange', 'yellow', 'green', 'purple']
      @master = Master.new(self)
      @hacker = Hacker.new(self)
    end

    def add_master_color!(color)
      @master_combination.push(color)
    end

    def play
      # master_turn
      puts "Guess the colors and their order!"
      @hacker.colors_loop
      @hacker_combinations.push(@hacker.chosen_colors)
      turn_clues = []
      @hacker.chosen_colors.each_with_index do |c, i|
        turn_clues.push('B') if @master_combination.find_index(c) == i
        turn_clues.push('W') if @master_combination.include?(c)
        turn_clues.push(' ') unless @master_combination.include?(c)
      end
      @hacker_clues.push(turn_clues)
      p @master_combination
      p @hacker_combinations
      p @hacker_clues
      # for each color in hacker check if it is in the master array
      # if it is check if they have the same index
      # if they do return b
      # if the color is in the master but not in the position return w
      # if not return ' '
      # push hacker array and the tips array to hacker_combinations array
      # display previous attemps
      # repeat 10 times 
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
    
  end

  class Master < Player
  end

  class Hacker < Player
  end

end

include Mastermind

game = Game.new
game.play
require 'io/console'

module Mastermind
  class Game
    attr_reader :hidden_combination, :colors

    def initialize
      @master_combination = [] 
      @colors = ['red', 'blue', 'orange', 'yellow', 'green', 'purple']
      @master = Master.new(self)
      @hacker = Hacker.new(self)
    end

    def add_master_color!(color)
      @master_combination.push(color)
    end

    def play
      puts "Master turn to choose colors"
      @master.master_selects
    end

  end

  class Player
    def initialize(game)
      @game = game
      @chosen_color = ''
    end
    attr_reader :chosen_color

    def color_to_choose
      puts 'choose 4 colors from 1-6, input one number at a time and then click enter', @game.colors
    end


    def choose_color!
      color_index = STDIN.noecho(&:gets)
      @chosen_color = @game.colors[color_index.to_i] if right_input?(color_index.to_i)
    end

    def right_input?(index)
      if index < 0 || index > 5 || index.class != Integer
        puts 'wrong input!'
        choose_color!
      end
      true
    end
    
  end

  class Master < Player
    def master_selects
      color_to_choose
      4.times do 
        choose_color!
        @game.add_master_color!(@chosen_color)
        @chosen_color = ''
      end
    end

  end

  class Hacker < Player
  end

end

include Mastermind

game = Game.new
game.play
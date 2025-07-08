module Mastermind
  class Game
    attr_reader :hidden_combination, :colors

    def initialize
      @hidden_combination = [] 
      @colors = ['red', 'blue', 'orange', 'yellow', 'green', 'purple']
      @master = Master.new(self)
    end

    def add_hidden_color!(color)
      @hidden_combination.push(color)
    end

    def play
      @master.master_selects
      p @hidden_combination
    end

    def handle_wrong_input
      
    end

  end

  class Player
    def initialize(game)
      @game = game
      @chosen_color = ''
    end
    attr_reader :chosen_color

    def choose_color!
      puts 'choose 1 color from 1-6', @game.colors
      color_index = gets.to_i - 1
      @chosen_color = @game.colors[color_index]
    end
  end

  class Master < Player
    def master_selects
      4.times do 
        choose_color!
        @game.add_hidden_color!(@chosen_color)
        @chosen_color = ''
      end
    end

  end

end

include Mastermind

game = Game.new
game.play
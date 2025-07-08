module Mastermind
  class Game
    attr_reader :hidden_combination, :chosen_color, :colors

    def initialize
      @hidden_combination = [] 
      @colors = ['red', 'blue', 'orange', 'yellow', 'green', 'purple']
      @chosen_color = ''
    end

    def choose_color
      puts 'choose 1 color from 1-6', @colors
      color_index = gets.to_i - 1
      @chosen_color = @colors[color_index]
    end

    def add_color(array)
      array.push(@chosen_color)
    end

    def master_selection
      4.times do 
        choose_color
        add_color(@hidden_combination)
        @chosen_color = ''
      end
    end

  end
end

include Mastermind

game = Game.new
game.master_selection
p game.hidden_combination
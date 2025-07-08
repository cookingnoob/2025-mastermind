module Mastermind
  class Game
    attr_reader :hidden_combination, :chosen_color

    def initialize
      @hidden_combination = Array.new(4) {' '} 
      @colors = ['red', 'blue', 'orange', 'yellow', 'green', 'purple']
      @chosen_color = ''
    end

    def choose_color
      puts 'choose 1 color from 1-6', @colors
      color_index = gets.to_i - 1
      @chosen_color = @colors[color_index]
    end

  end
end

include Mastermind

game = Game.new
game.choose_color
p game.chosen_color
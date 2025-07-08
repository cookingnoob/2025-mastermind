module Mastermind
  class Game
    attr_reader :hidden_combination

    def initialize
      @hidden_combination = Array.new(4) {' '} 
      @colors = ['red', 'blue', 'orange', 'yellow', 'green', 'purple']
    end

  end
end

include Mastermind

game = Game.new
p game.hidden_combination
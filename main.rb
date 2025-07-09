require 'io/console'

module Mastermind
  class Game
    attr_reader :hidden_combination, :colors, :master_combination, :hacker_combinations

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
      puts "Guess the colors and their order!"
      hacker_turn
      winner?
      display_results
      # repeat 10 times 
    end

    def display_results
      @hacker_combinations.each_with_index do |comb, i|
        puts "turn #{i + 1} combination: #{comb}        clues: #{@hacker_clues[i]}"
      end
    end

    def winner?
     if @hacker.chosen_colors ==  @master_combination
       puts "Hacker has guessed the combination, hacker wins!!"
       exit 
     end
    end

    def master_turn
      puts "Master turn to choose colors"
      @master.colors_loop
      @master_combination = @master.chosen_colors      
    end

    def hacker_turn
      @hacker.colors_loop
      @hacker_combinations.push(@hacker.chosen_colors)
      automated_clues
    end

    def automated_clues
      @hacker_clues.push(clues_loop)
    end

    def clues_loop(array = [])
      @hacker.chosen_colors.each_with_index do |c, i|
         clues_conditionals(c, i, array)
      end
      array.shuffle
    end

    def clues_conditionals(c, i, array)
      if @master_combination.find_index(c) == i
        array.push('B') 
      elsif @master_combination.include?(c)
        array.push('W')
      else 
        array.push(' ') 
      end
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
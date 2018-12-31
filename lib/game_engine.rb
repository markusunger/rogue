require_relative 'level'

# class GameEngine
# ----------------
# manages overall game state and creates new floors,
# also forwards actions to queue from the view

class GameEngine
  attr_accessor :has_won, :has_lost
  attr_reader :last_round

  def initialize
    @floor_number = 1
    @level = Level.new(@floor_number)
    has_won, has_lost = [false, false]
  end

  def request(command, param = nil)
    @level.controller.enqueue(command, param)
  end

  def process_queue
    @level.execute_actions
  end

  def process_turn
    @level.process_turn
    if @level.win_state
      @floor_number += 1
      if @floor_number == 11
        @has_won = true
        @floor_number = 1
        @last_round = @level.draw
        @level = Level.new(@floor_number)
      end
      @level.next(@floor_number)
    elsif @level.loss_state
      @floor_number = 1
      @last_round = @level.draw
      @level = Level.new(@floor_number)
      @has_lost = true
    end
  end

  def draw
    @level.draw
  end
end







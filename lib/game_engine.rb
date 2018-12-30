require_relative 'level'

# class GameEngine
# ----------------
# manages overall game state and creates new floors,
# also forwards actions to queue from the view

class GameEngine
  def initialize
    @floor_number = 1
    @level = Level.new(@floor_number)
  end

  def request(command, param = nil)
    @level.controller.enqueue(command, param)
  end

  def process_turn
    @level.process_turn
    if @level.win_state
      @floor_number += 1
      @level = Level.new(@floor_number)
    end
  end

  def draw
    @level.draw
  end
end







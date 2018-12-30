require_relative 'level'

# class GameEngine
# ----------------
# manages overall game state and creates new floors,
# also forwards actions to queue from the view

class GameEngine
  def initialize
    @level = Level.new
  end

  def request(command, param = nil)
    @level.controller.enqueue(command, param)
    # immediately execute the queue if reset is triggered
    @level.execute_actions if command == 'reset'
  end

  def process_turn
    @level.process_turn
    if @level.win_state
      @level.controller.enqueue('reset')
      @level.controller.enqueue('win')
      @level.execute_actions
    end
  end

  def draw
    @level.draw
  end
end







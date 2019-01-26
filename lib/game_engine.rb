require_relative 'level'
require_relative 'action_controller'
require_relative 'game_actions'
require_relative 'log'
require_relative 'combat'

# class GameEngine
# ----------------
# manages overall game state, turn order and controller actions,
# can take action requests from the view (relayed by the thin Sinatra layer)

class GameEngine
  include GameActions

  FLOORS_TO_WIN = 10  # no. of floors until overall victory

  attr_accessor :level, :has_won, :has_lost, :has_started
  attr_reader :last_round

  def initialize
    @controller   = ActionController.new
    @floor_number = 1
    @level        = Level.new(@floor_number)
    @log          = Log.new

    has_won, has_lost, has_started = [false, false, false]
  end

  def request(command, param = nil)
    @controller.enqueue(command, param)
  end

  def process_queue
    # removes any residual markers and executes the controller queue
    reset_markers(@level.map)
    messages = @controller.execute(self)
    messages.each do |m|
      @log << m if m && m.strip.size > 0
    end
  end

  def process_turn
    # enqueues actions for all enemies, executes the queue,
    # updates player state (energy/block gains)
    # and checks for win/loss conditions afterwards
    enemies = @level.enemies
    player = @level.player

    enemies.each do |enemy|
      @controller.enqueue('act_enemy', enemy.position)
    end
    process_queue
    player.process_turn

    if level_won?
      level_won_actions
    elsif game_lost?
      game_lost_actions
    end
  end

  def draw
    # passes along the complete level state and adds log and win state
    draw_object = @level.draw
    draw_object[:log] = @log
    draw_object[:win_state] = level_won?
    draw_object
  end
end







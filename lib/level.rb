require_relative 'map'
require_relative 'player'
require_relative 'enemy'
require_relative 'log'
require_relative 'action_controller'
require_relative 'round_actions'
require_relative 'combat'

# class Level
# -----------
# manages everything belonging to an individual level, the map, the log,
# the player, the enemies and the controller that executes all actions
# regarding those objects.

class Level
  include RoundActions

  attr_reader :controller, :win_state

  def initialize
    @log = Log.new
    @controller = ActionController.new
    prepare_map
  end

  def reset
    prepare_map
    ''
  end

  def execute_actions
    messages = @controller.execute(self)
    messages.each { |m| @log << m if m.size > 0 }
  end

  def process_turn
    @enemies.each do |enemy|
      @controller.enqueue('act_enemy', enemy.position)
    end
    @controller.enqueue('check_for_win_state')
    execute_actions
    @player.process_turn
  end

  def draw
    {
      map: to_enum(:render_map),
      width: @map.width,
      height: @map.height,
      log: @log,
      player: @player,
      enemies: @enemies
    }
  end

  private

  def prepare_map
    @map = Map.new(8,8)
    @player = Player.new
    @enemies = []
    init_player_position
    add_enemies(2)
  end
end
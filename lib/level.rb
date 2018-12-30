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

  def initialize(floor_number)
    @floor_number = floor_number
    @log = Log.new
    @controller = ActionController.new
    no_of_enemies = (floor_number / 2)
    no_of_enemies += 1 if no_of_enemies == 0
    prepare_map(no_of_enemies)
  end

  def reset
    prepare_map
    ''
    @level.execute_actions
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
      enemies: @enemies,
      floor_number: @floor_number
    }
  end

  private

  def prepare_map(no_of_enemies)
    @map = Map.new(8,8)
    @player = Player.new
    @enemies = []
    init_player_position
    add_enemies(no_of_enemies)
  end
end
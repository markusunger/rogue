require_relative 'map'
require_relative 'player'
require_relative 'enemies'

# class Level
# -----------
# manages everything belonging to an individual level: the map, the player
# and the enemies. Knows how to prepare itself for each new floor number

class Level

  attr_reader :map, :player, :enemies

  def initialize(floor_number)
    @map = nil
    @floor_number = floor_number
    @player = Player.new
    prepare_map
  end

  def next(floor_number)
    @floor_number = floor_number
    @player.refresh
    prepare_map
  end

  def draw
    map_enum = to_enum(:render_map)
    {
      map: map_enum,
      width: @map.width,
      height: @map.height,
      player: @player,
      enemies: @enemies,
      floor_number: @floor_number
    }
  end

  private

  def prepare_map
    @map = Map.new(8,8)
    no_of_enemies = (@floor_number / 2)
    no_of_enemies += 1 if no_of_enemies == 0
    @enemies = []
    init_player_position
    add_enemies(no_of_enemies)
  end

  def render_map(&block)
    # determines what entity, unit or tile to actually output in the frontend,
    # considering both background an foreground styles
    enum = @map.draw
    enum.each do |tile, position|
      to_draw = nil
      info = []
      possible_unit = @enemies.find { |a| a.position == position }

      if possible_unit
        info << "Enemy: #{possible_unit.name} (#{possible_unit.hp}/#{possible_unit.max_hp})" 
      end 

      if position == @player.position
        possible_unit = @player 
        info << "You are here!"
      end
      info << "Tile: #{tile[:name].capitalize}"

      to_draw = [{
        symbol: possible_unit&.symbol || tile[:symbol],
        style: possible_unit&.style || tile[:style],
        bgstyle: tile[:bgstyle]
      }, position, info]

      yield(to_draw) if block_given?
    end
  end

  def init_player_position
    # randomly set player starting position to a free tile
    starting_position = @map.farthest_from_exit
    @player.move(starting_position, @map)
  end

  def add_enemies(no)
    # Create a list of Enemy classes that are suited for this floor
    enemies_for_floor = [Goblin, Orc, GiantSpider]
    .select { |e| e.spawns_on_floor.cover?(@floor_number) }

    # add appropriate enemies to list of enemies and spawn them
    no.times do
      new_enemy = enemies_for_floor.sample.new
      spawn = nil
      loop do
        spawn = @map.find_enemy_spawn(@player.position)
        break unless @enemies.find { |e| e.position == spawn }
      end
      new_enemy.move(spawn, @map)
      @enemies << new_enemy
    end
  end
end
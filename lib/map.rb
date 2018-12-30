require_relative 'cavegen'
require_relative 'entities'
require_relative 'pathfinder'

require_relative 'tiles/tile'
require_relative 'tiles/floor'
require_relative 'tiles/wall'
require_relative 'tiles/exit'

# class Map
# ---------
# creates a new floor map, converts it into the proper format
# and handles all requests regarding pathfinding, tile accessibility,
# tile rendering and special tile placement (e.g. exits, enemy spawns)

class Map
  attr_reader :width, :height

  ADJACENT = [
    [-1,-1], [0, -1], [1, -1],
    [-1, 0],          [1,  0],
    [-1, 1], [0,  1], [1,  1]
  ]

  def initialize(width, height)
    @width = width
    @height = height
    @entities = Entities::table

    @map = CaveGenerator.new(width, height).generate
    create_tiles
    add_exit
  end

  def create_tiles
    @map = @map.map do |position, tile_info|
      [position, tile_info == 'floor' ? Floor.new : Wall.new ]
    end.to_h
  end

  def add_exit
    # find corner position for the exit
    suitable = find_free_tiles.select do |position| 
      walls_near = ADJACENT.reduce(0) do |walls, neighbor|
        x, y = position
        dx, dy = neighbor
        @map[[x+dx,y+dy]].is_a?(Wall) ? walls + 1 : walls
      end
      walls_near >= 3
    end
    @map[suitable.sample] = Exit.new
  end

  def find_free_tiles
    # a simple filter for all walkable tiles, should probably
    # take into account entities/enemies/player if used
    # for anything later in a floor life
    @map.select { |_, tile| tile.walkable? }.keys
  end

  def walkable?(position)
    @map[position].walkable
  end

  def exit_position
    @map.find { |_, tile| tile.is_a?(Exit) }.to_a.first
  end

  def adjacent?(position, other_position)
    x, y = position
    ADJACENT.any? { |dx, dy| [x+dx,y+dy] == other_position }
  end

  def find_enemy_spawn(player_position)
    # selects enemy spawn locations in a certain 
    # distance to the player (currently 2 to 6 tiles)
    p = Pathfinder.new(self)
    p.distances_from(player_position)
      .select { |k, v| (2..6).cover?(v) }
      .to_a
      .sample[0]
  end

  def farthest_from_exit
    # sorts all tiles by distance to the exit
    # and returns one of the three farthest
    paths = Pathfinder.new(self)
    paths
      .distances_from(exit_position)
      .sort { |a, b| b[1] <=> a[1] }
      .take(3)
      .sample
      .first
  end

  def closer_to_player(from_position, player_position)
    paths = Pathfinder.new(self)
    paths.path_to(from_position, player_position)
  end

  def active_tiles_in_range(position, range)
    paths = Pathfinder.new(self)
    paths
      .distances_from(position)
      .select { |k, v| v <= range && @map[k].walkable? }
      .map { |k, v| k }
  end

  def add_entity(position, name)
    @map[position].entities << name
  end

  def remove_all_entities(name)
    @map.each { |_, tile| tile.entities.delete(name) }
  end

  def draw(&block)
    return to_enum(:draw) unless block_given?
    @width.times do |y|
      @height.times do |x|
        yield(what_to_draw(x, y), [x,y])
      end
    end
  end

  def what_to_draw(x, y)
    # determines what to draw for each tile (not considering units)
    # and its entities
    tile = @map[[x,y]]
    if tile.entities.size > 0
      e = tile.entities.first # TODO: order for multiple entities
      {
        symbol: @entities[e][:symbol],
        style: @entities[e][:style],
        bgstyle: @entities[e][:bgstyle]
      }
    else
    {
      symbol: tile.symbol,
      style: tile.style,
      bgstyle: tile.bgstyle
    }
    end
  end
end
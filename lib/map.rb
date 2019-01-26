require_relative 'cavegen'
require_relative 'entities'
require_relative 'pathfinder'

Dir[File.dirname(__FILE__) + '/tiles/*.rb'].each do |s|
  require_relative 'tiles/' + File.basename(s, '.rb')
end

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

  ENEMY_SPAWN_DISTANCE = (3..6) # distance from player in which enemies spawn

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
    # find corner position for the exit, identified by having just 3 floor neighbors
    suitable = find_free_tiles.select do |position| 
      floors_near = ADJACENT.reduce(0) do |floors, neighbor|
        x, y = position
        dx, dy = neighbor
        if @map[[x+dx,y+dy]].is_a?(Floor)
          floors + 1
        else
          floors
        end
      end
      floors_near == 3
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
    @map
      .find { |_, tile| tile.is_a?(Exit) }
      .to_a
      .first
  end

  def adjacent?(position, other_position)
    x, y = position
    ADJACENT.any? do |dx, dy|
      [x+dx,y+dy] == other_position
    end
  end

  def find_enemy_spawn(player_position)
    # selects enemy spawn locations in a certain 
    # distance to the player
    p = Pathfinder.new(self)
    p.distances_from(player_position)
      .select { |k, v| ENEMY_SPAWN_DISTANCE.cover?(v) }
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
    # returns an array of all positions that would be closer to the player
    paths = Pathfinder.new(self)
    bfs_map = paths.full_map(from_position, player_position)
    current_range = bfs_map[player_position][0]
    steps = bfs_map
      .select { |k, v| adjacent?(k, from_position) && v[0] < current_range }
      .map { |a, b| a }
    [bfs_map[player_position][1].first] + steps
  end

  def active_tiles_in_range(position, range)
    # returns an array of all walkable tiles in a certain range
    paths = Pathfinder.new(self)
    paths
      .distances_from(position)
      .select { |k, v| v <= range && @map[k].walkable? }
      .map { |k, v| k }
  end

  def in_range?(range, position, other_position)
    # checks if a position is in a certain range of another one
    paths = Pathfinder.new(self)
    paths
      .distances_from(position)
      .select { |k, v| k == other_position && v <= range }
      .size > 0 
  end

  def lootable_skills(position)
    @map[position].entities
      .select { |name| name == :loot }
      .size
  end

  def add_entity(position, name)
    @map[position].entities << name
  end

  def remove_all_entities(name)
    @map.each { |_, tile| tile.entities.delete(name) }
  end

  def remove_specific_entities(name, position)
    @map[position].entities.delete_if { |e| e == name }
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
      # sort entities by priority to determine which is displayed (e.g. markers first)
      return_hsh = tile.entities 
        .sort { |a, b| @entities[a][:priority] <=> @entities[b][:priority] } 
        .each_with_object({}) do |e, hsh|
          hsh[:symbol] = @entities[e][:symbol] if @entities[e][:symbol]
          hsh[:style] = @entities[e][:style] if @entities[e][:style]
          hsh[:bgstyle] = @entities[e][:bgstyle] if @entities[e][:bgstyle]
          hsh[:name] = e.to_s.capitalize
        end
      return_hsh[:symbol] = tile.symbol unless return_hsh[:symbol]
      return_hsh[:style] = tile.style unless return_hsh[:style]
      return_hsh[:bgstyle] = tile.bgstyle unless return_hsh[:bgstyle]
      return_hsh[:name] = tile.name unless return_hsh[:name]
      return_hsh
    else
    {
      symbol: tile.symbol,
      style: tile.style,
      bgstyle: tile.bgstyle,
      name: tile.name
    }
    end
  end
end
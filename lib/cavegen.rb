class CaveGenerator

  WALL_CHANCE    = 0.3  # chance for an initial wall
  ITERATIONS     = 3    # no. of generations for the automaton to simulate
  WALL_EVOLUTION = 5    # minimum neighbor walls to grow a new one
  WALL_STARVE    = 1    # minimum neighbor walls to not vanish

  FLOOR_TILE     = 'floor'
  WALL_TILE      = 'wall'

  attr_reader :width, :height, :map
  
  def initialize(width, height)
    @width = width
    @height = height

    @map = Hash.new
    @width.times do |y|
      @height.times do |x|
        tile = rand > WALL_CHANCE ? FLOOR_TILE : WALL_TILE
        @map[[x,y]] = tile
      end
    end
  end

  def generate
    ITERATIONS.times do
      new_map = Hash.new
      @width.times do |y|
        @height.times do |x|
          if neighbors(x,y) >= WALL_EVOLUTION
            new_map[[x,y]] = WALL_TILE 
          elsif neighbors(x,y) <= WALL_STARVE
            new_map[[x,y]] = FLOOR_TILE
          else
            new_map[[x,y]] = (2..3).cover?(neighbors(x,y)) ? @map[[x,y]] : FLOOR_TILE
          end
        end
      end
      @map = new_map
    end

    (0..width).each do |y|
      (0..height). each do |x|
        @map[[x,y]] = WALL_TILE if x == 0 || x == width-1 || y == 0 || y == width-1
      end
    end
    @map
  end

  def neighbors(x,y)
    adjacent = [
      [-1,-1], [0, -1], [1, -1],
      [-1, 0],          [1, 0],
      [-1, 1], [0, 1],  [1, 1]
    ]
    adjacent.reduce(0) do |count, c|
      if @map.fetch([x+c[0],y+c[1]], WALL_TILE) == WALL_TILE
        count += 1
      else
        count
      end
    end
  end
end
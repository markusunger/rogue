class CaveGenerator

  WALL_CHANCE    = 0.25 # chance for an initial wall
  ITERATIONS     = 1    # no. of generations for the automaton to simulate
  WALL_EVOLUTION = 5    # minimum neighbor walls to grow a new one
  WALL_STARVE    = 2    # minimum neighbor walls to not vanish

  FLOOR_TILE     = 'floor'
  WALL_TILE      = 'wall'

  attr_reader :width, :height, :map
  
  def initialize(width, height)
    @width = width
    @height = height

    @map = Hash.new
    @width.times do |y|
      @height.times do |x|
        tile = nil
        if x == 0 || x == @height-1 || y == 0 || y == @width-1
          tile = WALL_TILE
        else
          tile = rand > WALL_CHANCE ? FLOOR_TILE : WALL_TILE
        end
        @map[[x,y]] = tile
      end
    end
  end

  def generate
    ITERATIONS.times do
      new_map = @map.clone
      @width.times do |y|
        @height.times do |x|
          new_map[[x,y]] = WALL_TILE if neighbors(x,y) >= WALL_EVOLUTION
          if neighbors(x,y) <= WALL_STARVE
            new_map[[x,y]] = FLOOR_TILE unless x == 0 || y == 0 || x == @width - 1 || y == @height - 1
          end
        end
      end

      @map = new_map
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
      @map.fetch([x+c[0],y+c[1]], WALL_TILE) == WALL_TILE ? count += 1 : count
    end
  end
end
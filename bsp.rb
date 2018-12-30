FLOOR_TILE = '.'
WALL_TILE  = '#'
ROOM_NO    = 10
WIDTH      = 20
HEIGHT     = 20

MARKERS    = ['X', 'O', '-']

class Dungeon
  def initialize
    @rooms = SubDungeon.new
    @map = Hash.new
    WIDTH.times do |x|
      HEIGHT.times do |y|
        if x == 0 || x == height || y == 0 || y == width
          @map["#{x},#{y}"] = WALL_TILE
        else
          @map["#{x},#{y}"] = FLOOR_TILE
        end
      end
    end

    @rooms.split

    @rooms.each_with_index do |room, idx|
      
  end
end

class SubDungeon
  def initialize(init_point = [0,0], width, height)
    @init   = init_point
    @width  = width
    @height = height
    @childs = []
  end

  def split
    direction = rand > 0.5 ? :vertical : :horizontal
    if direction == :vertical
      @childs << SubDungeon.new(@init, @width / 2, @height)
      @childs << SubDungeon.new([@init[0] + @width / 2,@init[1]], @width / 2, @height)
    else
      @childs << SubDungeon.new(@init, @width, @height / 2)
      @childs << SubDungeon.new([@init[0],@init[1] + @height / 2], @width / 2, @height)
    end
  end

  def each(&block)
    unless @childs.empty?
      @childs.each { |c| c.each(&block) }
    end
    yield [@init, @width, @height]
  end
end
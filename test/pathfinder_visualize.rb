require_relative 'cavegen'
require 'colorize'

class BreadthFirstSearch
  def initialize(root_position, map)
    @map = map
    @root = Node.new(root_position)
    @explore = []
    @visited = Hash.new(nil)
  end
  
  def search
    @explore << @root
    @visited[@root.position] = [0, []] # save both distance and path to tile
    until @explore.empty? do
      current = @explore.shift
      current.neighbors.each do |neighbor|
        nx, ny = neighbor
        unless @visited[neighbor] && nx <= @map.width - 1 && ny <= @map.height - 1
          if @map.walkable?(neighbor)
            draw_map(neighbor, @visited)
            @explore << Node.new(neighbor) 
            @visited[neighbor] = [
              @visited[current.position][0] + 1,
              @visited[current.position][1] + [neighbor]
            ]
          end
        end
      end
    end
    # returns a hash with the positions as keys and an array
    # as values that holds (0) the distance to the original tile
    # and (1) a set of coordinates to travel to get to the 
    # original tile
    @visited
  end

  def draw_map(neighbor, visited)
    system('cls') || system('clear')
    @map.width.times do |y|
      @map.height.times do |x|
        if [x,y] == neighbor
          print 'X'.red
        elsif visited.has_key?([x,y])
          print visited[[x,y]][0].to_s.green
        else
          @map.map[[x,y]] == '.' ? print(@map.map[[x,y]].yellow) : print(@map.map[[x,y]].black.on_light_black)
        end
      end
      puts
    end
    sleep(0.2)
  end
end

# class Node
# ----------
# represents a single node in the BFS graph, mostly for neighbor management

class Node 
  def initialize(position)
    @x, @y = position
  end

  def position
    [@x,@y]
  end

  def neighbors
    adjacent = [
      [-1,-1], [0, -1], [1, -1],
      [-1, 0],          [1, 0],
      [-1, 1], [0, 1],  [1, 1]
    ]
    adjacent.map { |dx, dy| [@x+dx,@y+dy] }
  end
end

class Map
  attr_reader :width, :height, :map

  ADJACENT = [
    [-1,-1], [0, -1], [1, -1],
    [-1, 0],          [1,  0],
    [-1, 1], [0,  1], [1,  1]
  ]

  def initialize(width, height)
    @width = width
    @height = height

    @map = CaveGenerator.new(width, height, 0.35, 3, 5, 2).generate
  end

  def walkable?(position)
    @map[position] == '.'
  end
end

map = Map.new(10,10)

BreadthFirstSearch.new([5,5], map).search
# class Pathfinder
# ----------------
# building on top of the BFS graph, handles requests
# for certain pathfinding mechanisms, e.g. distance search
# or shortest path generation

class Pathfinder
  def initialize(map)
    @map = map
  end

  def distances_from(origin)
    BreadthFirstSearch.new(origin, @map)
      .search
      .map { |k, v| [k, v[0]] }
      .to_h
  end

  def full_map(origin, target)
    BreadthFirstSearch.new(origin, @map).search
  end

  def path_to(origin, target)
    distances = BreadthFirstSearch.new(origin, @map).search
    distances[target][1].first
  end
end

# class BreadthFirstSearch
# ------------------------
# implements a graph-based breadth-first search according to
# https://en.wikipedia.org/wiki/Breadth-first_search

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
        unless @visited[neighbor] 
          if @map.walkable?(neighbor)
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
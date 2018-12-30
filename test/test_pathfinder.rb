require_relative '../lib/map'
require_relative '../lib/pathfinder'

map = Map.new(20,20)
enum = map.draw

paths = Pathfinder.new(map).distances_from("9,9")

map.width.times do |y|
  map.height.times do |x|
    if paths["#{x},#{y}"]
      print paths["#{x},#{y}"]
      enum.next
    else
      print enum.next[0][:symbol]
    end
  end
  puts
end
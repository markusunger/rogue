require_relative 'cavegen'
require 'colorize'

x,y = [15,15]
wall_chance = 0.5
iterations = 5
evolution = 5
starve = 3


loop do
  map = CaveGenerator.new(x, y, wall_chance, iterations, evolution, starve).generate
  system('clear') || system('cls')
  puts
  puts

  y.times do |y|
    print "  "
    x.times do |x|
      map[[x,y]] == '.' ? print('.'.light_yellow) : print('#'.light_black)
    end
    puts
  end
  
  puts
  puts "  Initial Wall Chance: #{wall_chance}"
  puts "  Iterations: #{iterations}"
  puts "  New wall on: > #{evolution} wall eighbors"
  puts "  Wall removed on: <= #{starve} wall neighbors"
  puts "  Wall kept on == 3 neighbors"

  sleep(0.5)
end
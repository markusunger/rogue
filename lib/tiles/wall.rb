require_relative 'tile'

class Wall < Tile
  def initialize
    super('wall', '#', ['wall1', 'wall2', 'wall3'].sample, '', false)
  end
end
require_relative 'tile'

class Floor < Tile
  def initialize
    super('floor', '.', ['floor1', 'floor2', 'floor3'].sample, 'bgfloor1', true)
  end
end
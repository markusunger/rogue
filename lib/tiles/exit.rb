require_relative 'tile'

class Exit < Tile
  def initialize
    super('exit', '¬', 'exit1', 'bgexit1', true)
  end
end
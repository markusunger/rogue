class Tile
  attr_accessor :entities
  attr_reader :name, :symbol, :style, :bgstyle, :walkable
  def initialize(name = 'placeholder', symbol = ' ', style = '', bgstyle = '', walkable = false)
    @name     = name
    @symbol   = symbol
    @style    = style
    @bgstyle  = bgstyle
    @walkable = walkable
    @entities = []
  end

  def walkable?
    @walkable
  end
end




# class Unit
# ----------
# superclass for both enemies and the player, manages general
# commands identical to both unit types, e.g. the act of moving,
# dealing and receiving damage, ...

class Unit
  attr_accessor :position
  attr_reader :id, :symbol, :style, :hp, :ap

  def initialize(symbol: ' ', style: '', hp: 10, ap: 10)
    @symbol = symbol
    @style = style
    @position = [0,0]
    @hp = hp
    @ap = ap
  end

  def move(new_position, map)
    self.position = new_position if map.walkable?(new_position)
  end

  def deal_dmg
    @ap
  end

  def take_dmg(dmg)
    @hp -= dmg
  end

  def dead?
    @hp <= 0
  end
end
# class Unit
# ----------
# superclass for both enemies and the player, manages general
# commands identical to both unit types, e.g. the act of moving,
# dealing and receiving damage, ...

class Unit
  attr_accessor :position
  attr_reader :symbol, :name, :style, :hp, :ap

  def initialize(symbol: ' ', name: 'generic unit', style: '', hp: 10, ap: 1)
    @symbol = symbol
    @name = name
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